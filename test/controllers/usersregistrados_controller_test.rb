require 'test_helper'

class UsersregistradosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @usersregistrado = usersregistrados(:one)
  end

  test "should get index" do
    get usersregistrados_url
    assert_response :success
  end

  test "should get new" do
    get new_usersregistrado_url
    assert_response :success
  end

  test "should create usersregistrado" do
    assert_difference('Usersregistrado.count') do
      post usersregistrados_url, params: { usersregistrado: { apellidos: @usersregistrado.apellidos, celular: @usersregistrado.celular, confirma_password: @usersregistrado.confirma_password, email: @usersregistrado.email, identificacion: @usersregistrado.identificacion, nombre: @usersregistrado.nombre, password: @usersregistrado.password, tiposconsulta: @usersregistrado.tiposconsulta, user_id: @usersregistrado.user_id } }
    end

    assert_redirected_to usersregistrado_url(Usersregistrado.last)
  end

  test "should show usersregistrado" do
    get usersregistrado_url(@usersregistrado)
    assert_response :success
  end

  test "should get edit" do
    get edit_usersregistrado_url(@usersregistrado)
    assert_response :success
  end

  test "should update usersregistrado" do
    patch usersregistrado_url(@usersregistrado), params: { usersregistrado: { apellidos: @usersregistrado.apellidos, celular: @usersregistrado.celular, confirma_password: @usersregistrado.confirma_password, email: @usersregistrado.email, identificacion: @usersregistrado.identificacion, nombre: @usersregistrado.nombre, password: @usersregistrado.password, tiposconsulta: @usersregistrado.tiposconsulta, user_id: @usersregistrado.user_id } }
    assert_redirected_to usersregistrado_url(@usersregistrado)
  end

  test "should destroy usersregistrado" do
    assert_difference('Usersregistrado.count', -1) do
      delete usersregistrado_url(@usersregistrado)
    end

    assert_redirected_to usersregistrados_url
  end
end
