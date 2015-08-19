require 'test_helper'

class SurveyResultsControllerTest < ActionController::TestCase
  setup do
    @survey_result = survey_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:survey_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create survey_result" do
    assert_difference('SurveyResult.count') do
      post :create, survey_result: { a1: @survey_result.a1, a2: @survey_result.a2, a3: @survey_result.a3, a4: @survey_result.a4, a5: @survey_result.a5, a6comment: @survey_result.a6comment, b1: @survey_result.b1, b2: @survey_result.b2, b3: @survey_result.b3, b4: @survey_result.b4, b5: @survey_result.b5, b6comment: @survey_result.b6comment, collector: @survey_result.collector, contact: @survey_result.contact, created: @survey_result.created, fid: @survey_result.fid, ip: @survey_result.ip, location: @survey_result.location, negfeedback: @survey_result.negfeedback, nps: @survey_result.nps, posfeedback: @survey_result.posfeedback, run: @survey_result.run, status: @survey_result.status, user_id: @survey_result.user_id }
    end

    assert_redirected_to survey_result_path(assigns(:survey_result))
  end

  test "should show survey_result" do
    get :show, id: @survey_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survey_result
    assert_response :success
  end

  test "should update survey_result" do
    patch :update, id: @survey_result, survey_result: { a1: @survey_result.a1, a2: @survey_result.a2, a3: @survey_result.a3, a4: @survey_result.a4, a5: @survey_result.a5, a6comment: @survey_result.a6comment, b1: @survey_result.b1, b2: @survey_result.b2, b3: @survey_result.b3, b4: @survey_result.b4, b5: @survey_result.b5, b6comment: @survey_result.b6comment, collector: @survey_result.collector, contact: @survey_result.contact, created: @survey_result.created, fid: @survey_result.fid, ip: @survey_result.ip, location: @survey_result.location, negfeedback: @survey_result.negfeedback, nps: @survey_result.nps, posfeedback: @survey_result.posfeedback, run: @survey_result.run, status: @survey_result.status, user_id: @survey_result.user_id }
    assert_redirected_to survey_result_path(assigns(:survey_result))
  end

  test "should destroy survey_result" do
    assert_difference('SurveyResult.count', -1) do
      delete :destroy, id: @survey_result
    end

    assert_redirected_to survey_results_path
  end
end
