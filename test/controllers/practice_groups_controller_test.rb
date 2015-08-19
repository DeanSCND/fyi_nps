require 'test_helper'

class PracticeGroupsControllerTest < ActionController::TestCase
  setup do
    @practice_group = practice_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:practice_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create practice_group" do
    assert_difference('PracticeGroup.count') do
      post :create, practice_group: { name: @practice_group.name }
    end

    assert_redirected_to practice_group_path(assigns(:practice_group))
  end

  test "should show practice_group" do
    get :show, id: @practice_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @practice_group
    assert_response :success
  end

  test "should update practice_group" do
    patch :update, id: @practice_group, practice_group: { name: @practice_group.name }
    assert_redirected_to practice_group_path(assigns(:practice_group))
  end

  test "should destroy practice_group" do
    assert_difference('PracticeGroup.count', -1) do
      delete :destroy, id: @practice_group
    end

    assert_redirected_to practice_groups_path
  end
end
