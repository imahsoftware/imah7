require 'test_helper'

class ContratosperquejasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperqueja = contratosperquejas(:one)
  end

  test "should get index" do
    get contratosperquejas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperqueja_url
    assert_response :success
  end

  test "should create contratosperqueja" do
    assert_difference('Contratosperqueja.count') do
      post contratosperquejas_url, params: { contratosperqueja: { conciliar: @contratosperqueja.conciliar, conciliar_explique: @contratosperqueja.conciliar_explique, contratospersona_id: @contratosperqueja.contratospersona_id, fecha: @contratosperqueja.fecha, queja_desproteccion: @contratosperqueja.queja_desproteccion, queja_discriminacion: @contratosperqueja.queja_discriminacion, queja_entorpecimiento: @contratosperqueja.queja_entorpecimiento, queja_explica: @contratosperqueja.queja_explica, queja_inequidad: @contratosperqueja.queja_inequidad, queja_maltrato: @contratosperqueja.queja_maltrato, queja_persecucion: @contratosperqueja.queja_persecucion, queja_pruebas: @contratosperqueja.queja_pruebas } }
    end

    assert_redirected_to contratosperqueja_url(Contratosperqueja.last)
  end

  test "should show contratosperqueja" do
    get contratosperqueja_url(@contratosperqueja)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperqueja_url(@contratosperqueja)
    assert_response :success
  end

  test "should update contratosperqueja" do
    patch contratosperqueja_url(@contratosperqueja), params: { contratosperqueja: { conciliar: @contratosperqueja.conciliar, conciliar_explique: @contratosperqueja.conciliar_explique, contratospersona_id: @contratosperqueja.contratospersona_id, fecha: @contratosperqueja.fecha, queja_desproteccion: @contratosperqueja.queja_desproteccion, queja_discriminacion: @contratosperqueja.queja_discriminacion, queja_entorpecimiento: @contratosperqueja.queja_entorpecimiento, queja_explica: @contratosperqueja.queja_explica, queja_inequidad: @contratosperqueja.queja_inequidad, queja_maltrato: @contratosperqueja.queja_maltrato, queja_persecucion: @contratosperqueja.queja_persecucion, queja_pruebas: @contratosperqueja.queja_pruebas } }
    assert_redirected_to contratosperqueja_url(@contratosperqueja)
  end

  test "should destroy contratosperqueja" do
    assert_difference('Contratosperqueja.count', -1) do
      delete contratosperqueja_url(@contratosperqueja)
    end

    assert_redirected_to contratosperquejas_url
  end
end
