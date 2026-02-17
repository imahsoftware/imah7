require 'test_helper'

class AntecedentesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @antecedente = antecedentes(:one)
  end

  test "should get index" do
    get antecedentes_url
    assert_response :success
  end

  test "should get new" do
    get new_antecedente_url
    assert_response :success
  end

  test "should create antecedente" do
    assert_difference('Antecedente.count') do
      post antecedentes_url, params: { antecedente: { ant_10: @antecedente.ant_10, ant_11: @antecedente.ant_11, ant_12: @antecedente.ant_12, ant_13: @antecedente.ant_13, ant_1: @antecedente.ant_1, ant_2: @antecedente.ant_2, ant_3: @antecedente.ant_3, ant_3a: @antecedente.ant_3a, ant_3b: @antecedente.ant_3b, ant_3c: @antecedente.ant_3c, ant_3d: @antecedente.ant_3d, ant_3e: @antecedente.ant_3e, ant_4: @antecedente.ant_4, ant_4a: @antecedente.ant_4a, ant_5: @antecedente.ant_5, ant_5a: @antecedente.ant_5a, ant_6: @antecedente.ant_6, ant_7: @antecedente.ant_7, ant_8: @antecedente.ant_8, ant_9: @antecedente.ant_9, edad: @antecedente.edad, identificacion: @antecedente.identificacion, imc: @antecedente.imc, mayores60: @antecedente.mayores60, menores5: @antecedente.menores5, nombre: @antecedente.nombre, persona_id: @antecedente.persona_id, peso: @antecedente.peso, sexo: @antecedente.sexo, talla: @antecedente.talla } }
    end

    assert_redirected_to antecedente_url(Antecedente.last)
  end

  test "should show antecedente" do
    get antecedente_url(@antecedente)
    assert_response :success
  end

  test "should get edit" do
    get edit_antecedente_url(@antecedente)
    assert_response :success
  end

  test "should update antecedente" do
    patch antecedente_url(@antecedente), params: { antecedente: { ant_10: @antecedente.ant_10, ant_11: @antecedente.ant_11, ant_12: @antecedente.ant_12, ant_13: @antecedente.ant_13, ant_1: @antecedente.ant_1, ant_2: @antecedente.ant_2, ant_3: @antecedente.ant_3, ant_3a: @antecedente.ant_3a, ant_3b: @antecedente.ant_3b, ant_3c: @antecedente.ant_3c, ant_3d: @antecedente.ant_3d, ant_3e: @antecedente.ant_3e, ant_4: @antecedente.ant_4, ant_4a: @antecedente.ant_4a, ant_5: @antecedente.ant_5, ant_5a: @antecedente.ant_5a, ant_6: @antecedente.ant_6, ant_7: @antecedente.ant_7, ant_8: @antecedente.ant_8, ant_9: @antecedente.ant_9, edad: @antecedente.edad, identificacion: @antecedente.identificacion, imc: @antecedente.imc, mayores60: @antecedente.mayores60, menores5: @antecedente.menores5, nombre: @antecedente.nombre, persona_id: @antecedente.persona_id, peso: @antecedente.peso, sexo: @antecedente.sexo, talla: @antecedente.talla } }
    assert_redirected_to antecedente_url(@antecedente)
  end

  test "should destroy antecedente" do
    assert_difference('Antecedente.count', -1) do
      delete antecedente_url(@antecedente)
    end

    assert_redirected_to antecedentes_url
  end
end
