class StudentsController < ApplicationController
  def index
    @students = Student.all.order({ :created_at => :desc })

    render({ :template => "students/index" })
  end

  def show
    the_id = params.fetch("path_id")
    @student = Student.find(the_id)  # Using .find ensures an ActiveRecord::RecordNotFound exception if no record is found
    @enrollments = @student.enrollments.includes(:course)  # This 'includes' avoids N+1 query issues
  end

  def create
    @student = Student.new
    @student.first_name = params[:query_first_name]
    @student.last_name = params[:query_last_name]
    @student.email = params[:query_email]
  
    if @student.save
      redirect_to("/students", { notice: "Student created successfully." })
    else
      # Render the new template with error messages
      render("students/new", locals: { student: @student }, status: :unprocessable_entity)
    end
  end

  def update
    the_id = params.fetch("path_id")
    @student = Student.where({ :id => the_id }).at(0)

    @student.first_name = params.fetch("query_first_name")
    @student.last_name = params.fetch("query_last_name")
    @student.email = params.fetch("query_email")

    if @student.valid?
      @student.save
      redirect_to("/students/#{@student.id}", { :notice => "Student updated successfully."} )
    else
      redirect_to("/students/#{@student.id}", { :alert => "Student failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    @student = Student.where({ :id => the_id }).at(0)

    @student.destroy

    redirect_to("/students", { :notice => "Student deleted successfully."} )
  end
end
