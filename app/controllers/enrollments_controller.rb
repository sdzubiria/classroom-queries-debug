class EnrollmentsController < ApplicationController
  def create
    @enrollment = Enrollment.new(enrollment_params)
    if @enrollment.save
      redirect_to student_path(@enrollment.student_id), notice: 'Enrollment was successfully created.'
    else
      redirect_to student_path(@enrollment.student_id), alert: 'Failed to create enrollment.'
    end
  end

  private

  def enrollment_params
    params.require(:enrollment).permit(:course_id, :student_id)
  end
end
