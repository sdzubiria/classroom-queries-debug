class CoursesController < ApplicationController
  def index
    @courses = Course.all.order({ :created_at => :desc })

    render({ :template => "courses/index" })
  end

  def show
    the_id = params.fetch("path_id")
    @course = Course.where({:id => the_id }).at(0)

    render({ :template => "courses/show" })
  end

  def create
    Rails.logger.debug "Received params: #{params.inspect}"  # This line will log the parameters to your development log.
    @course = Course.new
    @course.title = params.fetch("query_title")
    @course.term_offered = params.fetch("query_term")
    @course.department_id = params.fetch("query_department_id")
  
    if @course.valid?
      @course.save
      redirect_to("/courses", { :notice => "Course created successfully." })
    else
      redirect_to("/courses", { :notice => "Course failed to create successfully." })
    end
  end
  

  def update
    @course = Course.find(params[:path_id])
    if @course.update(course_params) 
      redirect_to course_path(@course), notice: 'Course updated successfully.'
    else
      render 'edit', status: :unprocessable_entity
    end
  end
  
 
  def destroy
    the_id = params.fetch("path_id")
    @course = Course.where({ :id => the_id }).at(0)

    @course.destroy

    redirect_to("/courses", { :notice => "Course deleted successfully."} )
  end
end

private
def course_params
  params.require(:course).permit(:title, :term_offered, :department_id)
end
