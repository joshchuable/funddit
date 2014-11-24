class Projects::ContributionsController < ApplicationController
  inherit_resources
  actions :index, :show, :new, :update, :review, :create
  skip_before_filter :force_http
  skip_before_filter :verify_authenticity_token, only: [:moip]
  has_scope :available_to_count, type: :boolean
  has_scope :with_state
  has_scope :page, default: 1
  after_filter :verify_authorized, except: [:index]
  belongs_to :project
  before_filter :detect_old_browsers, only: [:new, :create]

  helper_method :avaiable_payment_engines

  def edit
    authorize resource
    if resource.reward.try(:sold_out?)
      flash[:alert] = t('.reward_sold_out')
      return redirect_to new_project_contribution_path(@project)
    end
  end

  def update
    authorize resource
    resource.update_attributes(permitted_params[:contribution])
    resource.update_user_billing_info
    render json: {message: 'updated'}
  end

  def index
    render collection
  end

  def show
    authorize resource
    @title = t('projects.contributions.show.title')
  end

  def new
    @contribution = Contribution.new(project: parent, user: current_user)
    authorize @contribution

    @title = t('projects.contributions.new.title', name: @project.name)
    empty_reward = Reward.new(minimum_value: 0, description: t('projects.contributions.new.no_reward'))
    @rewards = [empty_reward] + @project.rewards.remaining.order(:minimum_value)

    # Select
    if params[:reward_id] && (@selected_reward = @project.rewards.find params[:reward_id]) && !@selected_reward.sold_out?
      @contribution.reward = @selected_reward
      @contribution.value = "%0.0f" % @selected_reward.minimum_value
    end

      preapproval_params = {
            :period               => 'once',
            :end_time             => @project.by_expires_at
            :amount               => (contribution.price_in_cents/100).round(2).to_s,
            :mode                 => 'regular',
            :short_description    => t('wepay_description', scope: SCOPE, :project_name => contribution.project.name, :value => contribution.display_value),
            :app_fee              => "4",
            :fee_payer            => 'payee',
            :payer_email_message  => "You just approved Funddit to charge your preffered payment method if this project is successful. You have NOT been charged at this time!"
    }
    # Finally, send the user off to wepay for the preapproval
    init_preapproval_and_send_user_to_wepay(preapproval_params)
  end

  def create
    @title = t('projects.contributions.create.title')
    @contribution = Contribution.new(params[:contribution].merge(user: current_user, project: parent))
    @contribution.reward_id = nil if params[:contribution][:reward_id].to_i == 0
    authorize @contribution
    create! do |success,failure|
      failure.html do
        flash[:alert] = resource.errors.full_messages.to_sentence
        return redirect_to new_project_contribution_path(@project)
      end
      success.html do
        resource.update_current_billing_info
        flash[:notice] = nil
        session[:thank_you_contribution_id] = @contribution.id
        return redirect_to edit_project_contribution_path(project_id: @project.id, id: @contribution.id)
      end
    end
    @thank_you_id = @project.id
  end

  def gateway
    raise "[WePay] An API Client ID and Client Secret are required to make requests to WePay" unless PaymentEngines.configuration[:wepay_client_id] and PaymentEngines.configuration[:wepay_client_secret]
    @gateway ||= WePay.new(PaymentEngines.configuration[:wepay_client_id], PaymentEngines.configuration[:wepay_client_secret])
  end

  protected
  def permitted_params
    params.permit(policy(resource).permitted_attributes)
  end

  def avaiable_payment_engines
    engines = []

    if resource.value < 10
      engines.push PaymentEngines.find_engine('Credits')
    else
      if parent.using_pagarme?
        engines.push PaymentEngines.find_engine('Pagarme')
      else
        engines = PaymentEngines.engines.inject([]) do |total, item|
          if item.name == 'Credits' && current_user.credits > 0
            total << item
          elsif !item.name.match(/(Credits|Pagarme)/)
            total << item
          end

          total
        end
      end
    end

    @engines ||= engines
  end

  def collection
    @contributions ||= apply_scopes(end_of_association_chain).available_to_display.order("confirmed_at DESC").per(10)
  end
end
