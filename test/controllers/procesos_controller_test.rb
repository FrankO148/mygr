require 'test_helper'

class ProcesosControllerTest < ActionController::TestCase
  setup do
    @proceso = procesos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:procesos)
  end

  test "should create proceso" do
    assert_difference('Proceso.count') do
      post :create, proceso: { command: @proceso.command, p_cpu: @proceso.p_cpu, p_mem: @proceso.p_mem, pid: @proceso.pid, start: @proceso.start, stat: @proceso.stat, time: @proceso.time, tty: @proceso.tty, user: @proceso.user, vsz: @proceso.vsz }
    end

    assert_response 201
  end

  test "should show proceso" do
    get :show, id: @proceso
    assert_response :success
  end

  test "should update proceso" do
    put :update, id: @proceso, proceso: { command: @proceso.command, p_cpu: @proceso.p_cpu, p_mem: @proceso.p_mem, pid: @proceso.pid, start: @proceso.start, stat: @proceso.stat, time: @proceso.time, tty: @proceso.tty, user: @proceso.user, vsz: @proceso.vsz }
    assert_response 204
  end

  test "should destroy proceso" do
    assert_difference('Proceso.count', -1) do
      delete :destroy, id: @proceso
    end

    assert_response 204
  end
end
