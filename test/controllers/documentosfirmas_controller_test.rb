require 'test_helper'

class DocumentosfirmasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @documentosfirma = documentosfirmas(:one)
  end

  test "should get index" do
    get documentosfirmas_url
    assert_response :success
  end

  test "should get new" do
    get new_documentosfirma_url
    assert_response :success
  end

  test "should create documentosfirma" do
    assert_difference('Documentosfirma.count') do
      post documentosfirmas_url, params: { documentosfirma: { portafolio: @documentosfirma.portafolio, referencia_id: @documentosfirma.referencia_id, tabla: @documentosfirma.tabla, user_id: @documentosfirma.user_id } }
    end

    assert_redirected_to documentosfirma_url(Documentosfirma.last)
  end

  test "should show documentosfirma" do
    get documentosfirma_url(@documentosfirma)
    assert_response :success
  end

  test "should get edit" do
    get edit_documentosfirma_url(@documentosfirma)
    assert_response :success
  end

  test "should update documentosfirma" do
    patch documentosfirma_url(@documentosfirma), params: { documentosfirma: { portafolio: @documentosfirma.portafolio, referencia_id: @documentosfirma.referencia_id, tabla: @documentosfirma.tabla, user_id: @documentosfirma.user_id } }
    assert_redirected_to documentosfirma_url(@documentosfirma)
  end

  test "should destroy documentosfirma" do
    assert_difference('Documentosfirma.count', -1) do
      delete documentosfirma_url(@documentosfirma)
    end

    assert_redirected_to documentosfirmas_url
  end
end
