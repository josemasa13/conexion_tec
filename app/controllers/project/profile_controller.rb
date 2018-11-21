class Project::ProfileController < Project::BaseController
  before_action :set_project, only: [:show, :edit, :update]

	def show
	end

  # renders edit view
  def edit
  end

  # updates data in db
  def update
    students_params = params[:user][:project_attributes][:students]
    count = 0
    if students_params
      students_params.each do |key, params|
        puts("Param: #{params}")
        @user.project.students[count].update_attributes(student_params(params))
        count += 1
      end
      params[:user][:project_attributes][:students].delete(:students)
    end
    if @user.update_attributes(project_params)
      flash[:success] = "Información del proyecto actualizada"
      redirect_to project_profile_path
    else
      render "edit"
    end
  end

  private
    
    def set_project
      @project = current_project
      @user = @project.user
    end

    def project_params
      params.require(:user).permit(
        :id, :email, :password, :password_confirmation, :role, 
        project_attributes: [:id, :name, :field, :expertise_area_id, :client, 
        :abstract, :video_url, :status, :reason, :description, :category_id,
        professor_attributes: [:id, :name, :department, :course_code]])
    end

    def student_params(s_p)
      s_p.permit(:name, :major, :enrollment, :email)
    end
end
