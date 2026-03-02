import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/core/dto/resenea_dto.dart';
import 'package:iglesia_por_el_mundo_movil/features/reseneas/bloc/resenea_bloc.dart';

class FormularioReseneaPage extends StatefulWidget {
  const FormularioReseneaPage({super.key});

  @override
  State<FormularioReseneaPage> createState() => _FormularioReseneaPageState();
}

class _FormularioReseneaPageState extends State<FormularioReseneaPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _comentarioController = TextEditingController();

  int _calificacion = 0;
  DateTime? _fechaSeleccionada;

  @override
  void dispose() {
    _tituloController.dispose();
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  String _formatearFecha(DateTime date) {
    final mes = date.month.toString().padLeft(2, '0');
    final dia = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mes-$dia';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_calificacion == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona una calificación')),
        );
        return;
      }
      if (_fechaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona una fecha')),
        );
        return;
      }

      final dto = ReseneaDTO(
        tituloReseneas: _tituloController.text.trim(),
        calificacionResenea: _calificacion,
        comentarioResenea: _comentarioController.text.trim(),
        fechaResenea: _formatearFecha(_fechaSeleccionada!),
      );

      context.read<ReseneaBloc>().add(ReseneaSubmitted(dto));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReseneaBloc, ReseneaState>(
      listener: (context, state) {
        if (state is ReseneaCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Reseña enviada exitosamente!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is ReseneaError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ResenaLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FE),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Nueva Reseña',
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
                  // Título
                  const Text(
                    'Título',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _tituloController,
                    decoration: InputDecoration(
                      hintText: 'Ej: Excelente iglesia',
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

                  // Calificación
                  const Text(
                    'Calificación',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      final star = index + 1;
                      return GestureDetector(
                        onTap: () => setState(() => _calificacion = star),
                        child: Icon(
                          star <= _calificacion ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 36,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Comentario
                  const Text(
                    'Comentario',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _comentarioController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Comparte tu experiencia...',
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

                  // Fecha
                  const Text(
                    'Fecha',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _seleccionarFecha,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Color(0xFF2D3243), size: 20),
                          const SizedBox(width: 12),
                          Text(
                            _fechaSeleccionada != null
                                ? _formatearFecha(_fechaSeleccionada!)
                                : 'Seleccionar fecha',
                            style: TextStyle(
                              color: _fechaSeleccionada != null
                                  ? const Color(0xFF2D3243)
                                  : Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
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
                              'Enviar Reseña',
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
