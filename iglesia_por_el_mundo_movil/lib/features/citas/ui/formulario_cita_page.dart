import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/citas_dto.dart';
import 'package:iglesia_por_el_mundo_movil/core/models/tipo_citas.dart';
import 'package:iglesia_por_el_mundo_movil/features/citas/bloc/citas_bloc.dart';

class FormularioCitaPage extends StatefulWidget {
  const FormularioCitaPage({super.key});

  @override
  State<FormularioCitaPage> createState() => _FormularioCitaPageState();
}

class _FormularioCitaPageState extends State<FormularioCitaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _contactoController = TextEditingController();
  final _mensajeController = TextEditingController();
  
  DateTime? _fechaYHoraCita;
  TipoCitaResponse? _tipoCitaSeleccionada;
  List<TipoCitaResponse> _listaTipoCitas = [];

  @override
  void initState() {
    super.initState();
    // Cargar tipos de cita al abrir el formulario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CitasBloc>().add(CitasListarTipoCita());
      }
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _contactoController.dispose();
    _mensajeController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (date != null) {
      if (mounted) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(now),
        );

        if (time != null) {
          setState(() {
            _fechaYHoraCita = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
          });
        }
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_tipoCitaSeleccionada == null) {
        _showError('Por favor selecciona un tipo de cita');
        return;
      }

      if (_fechaYHoraCita == null) {
        _showError('Por favor selecciona fecha y hora de la cita');
        return;
      }

      if (_contactoController.text.trim().isEmpty) {
        _showError('El contacto es requerido');
        return;
      }

      final dto = CitasDto(
        nombre_solicitante: _nombreController.text.trim(),
        apellido_solicitante: _apellidoController.text.trim(),
        fecha_y_hora_cita: _fechaYHoraCita!,
        mensaje: _mensajeController.text.trim(),
        contacto: _contactoController.text.trim(),
        tipo_cita_id: _tipoCitaSeleccionada!.id,
      );

      context.read<CitasBloc>().add(CitasCrearCita(dto));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CitasBloc, CitasState>(
      listener: (context, state) {
        if (state is CitaCreada) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Cita creada exitosamente!'),
              backgroundColor: Colors.green,
            ),
          );
          // Recargar lista de citas
          context.read<CitasBloc>().add(CitasSubmitted());
          Navigator.of(context).pop();
        } else if (state is CitasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CitasLoading;

        // Actualizar lista de tipos de cita cuando se cargan
        if (state is TipoCitaListSuccess) {
          _listaTipoCitas = state.listaTipoCitas;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FE),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Nueva Solicitud de Cita',
              style: TextStyle(
                color: Color(0xFF2D3243),
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3243)),
              onPressed: () => Navigator.of(context).pop(),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 20),

                  // Tipo de Cita
                  const Text(
                    'Tipo de Cita',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: state is TipoCitaListLoading
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : _listaTipoCitas.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('No hay tipos de cita disponibles'),
                              )
                            : DropdownButton<TipoCitaResponse>(
                                value: _tipoCitaSeleccionada,
                                hint: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('Selecciona un tipo de cita'),
                                ),
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: _listaTipoCitas.map((tipoCita) {
                                  return DropdownMenuItem(
                                    value: tipoCita,
                                    child: Text(tipoCita.nombreCita),
                                  );
                                }).toList(),
                                onChanged: (TipoCitaResponse? value) {
                                  setState(() {
                                    _tipoCitaSeleccionada = value;
                                  });
                                },
                              ),
                  ),
                  const SizedBox(height: 20),

                  // Fecha y Hora de la Cita
                  const Text(
                    'Fecha y Hora de la Cita',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDateTime(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, color: Color(0xFF5C6BC0)),
                          const SizedBox(width: 12),
                          Text(
                            _fechaYHoraCita == null
                                ? 'Selecciona fecha y hora'
                                : '${_fechaYHoraCita!.day}/${_fechaYHoraCita!.month}/${_fechaYHoraCita!.year} - ${_fechaYHoraCita!.hour.toString().padLeft(2, '0')}:${_fechaYHoraCita!.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: _fechaYHoraCita == null ? Colors.grey : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Contacto
                  const Text(
                    'Contacto (Teléfono)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _contactoController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Tu número de teléfono',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 20),

                  // Mensaje
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
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Cuéntanos detalles de tu solicitud...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botón enviar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C6BC0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Solicitar Cita',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
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
