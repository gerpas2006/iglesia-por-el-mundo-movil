import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/donaciones_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/tipo_donacion.dart';
import 'package:iglesia_por_el_mundo_movil/core/service/donaciones_service.dart';
import 'package:iglesia_por_el_mundo_movil/features/donaciones/bloc/donaciones_bloc.dart';

class FormularioDonacionPage extends StatefulWidget {
  const FormularioDonacionPage({super.key});

  @override
  State<FormularioDonacionPage> createState() => _FormularioDonacionPageState();
}

class _FormularioDonacionPageState extends State<FormularioDonacionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _montoController = TextEditingController();
  final _mensajeController = TextEditingController();

  MetrodoPago _metodoSeleccionado = MetrodoPago.tarjeta;
  TipoDonacionResponse? _tipoDonacionSeleccionado;

  @override
  void initState() {
    super.initState();
    // Cargar tipos de donación cuando el widget se crea
    context.read<DonacionesBloc>().add(LoadTiposDonacion());
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _montoController.dispose();
    _mensajeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_tipoDonacionSeleccionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona un tipo de donación')),
        );
        return;
      }

      final monto = double.tryParse(_montoController.text) ?? 0.0;

      if (monto <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor ingresa un monto válido')),
        );
        return;
      }

      final dto = DonacionesDto(
        nombre_donante: _nombreController.text.trim(),
        apellido_donante: _apellidoController.text.trim(),
        donacion: monto,
        mensaje: _mensajeController.text.trim(),
        metodoPago: _metodoSeleccionado,
        tipo_donacion_id: _tipoDonacionSeleccionado!.id,
      );

      context.read<DonacionesBloc>().add(DonacionCreateRequested(dto));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DonacionesBloc, DonacionesState>(
      listener: (context, state) {
        if (state is DonacionCreada) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Donación registrada exitosamente!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is DonacionesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.mensaje}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is DonacionesLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FE),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Realizar Donación',
              style: TextStyle(
                color: Color(0xFF2D3243),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  const Text(
                    'Nombre',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      hintText: 'Tu nombre',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 20),

                  // Apellido
                  const Text(
                    'Apellido',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _apellidoController,
                    decoration: InputDecoration(
                      hintText: 'Tu apellido',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 20),

                  // Monto
                  const Text(
                    'Monto a Donar',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _montoController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'Ej: 50.00',
                      prefixText: '\$ ',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 20),

                  // Método de pago
                  const Text(
                    'Método de Pago',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: DropdownButton<MetrodoPago>(
                      value: _metodoSeleccionado,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: MetrodoPago.values
                          .map((metodo) => DropdownMenuItem(
                                value: metodo,
                                child: Text(
                                  metodo.toString().split('.').last,
                                  style: const TextStyle(
                                    color: Color(0xFF2D3243),
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _metodoSeleccionado = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tipo de donación
                  const Text(
                    'Tipo de Donación',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: state is DonacionesSuccess && state.tiposDonacion != null && state.tiposDonacion!.isNotEmpty
                        ? DropdownButton<TipoDonacionResponse>(
                            value: _tipoDonacionSeleccionado,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: const Text('Selecciona un tipo'),
                            items: state.tiposDonacion!
                                .map((tipo) => DropdownMenuItem(
                                      value: tipo,
                                      child: Text(tipo.nombreDonacion),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _tipoDonacionSeleccionado = value);
                              }
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              state is DonacionesLoading 
                                  ? 'Cargando tipos...'
                                  : state is DonacionesError 
                                      ? state.mensaje
                                      : 'No hay tipos disponibles',
                              style: TextStyle(
                                color: state is DonacionesLoading ? Colors.grey : Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Mensaje (opcional)
                  const Text(
                    'Mensaje (Opcional)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mensajeController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Cuéntanos por qué deseas donar...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botón enviar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Confirmar Donación',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
