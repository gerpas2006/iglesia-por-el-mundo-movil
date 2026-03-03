import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/perfil/bloc/perfil_bloc.dart';
import 'package:iglesia_por_el_mundo_movil/features/perfil/shared/informacion_usuario_widget.dart';
import 'package:iglesia_por_el_mundo_movil/features/perfil/shared/formulario_editar.dart';

class PerfilPage extends StatefulWidget {
  final void Function(int)? onNavigate;
  const PerfilPage({Key? key, this.onNavigate}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool _mostrando_formulario = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PerfilBloc()..add(LoadPerfilData()),
      child: _PerfilView(
        mostrandoFormulario: _mostrando_formulario,
        onToggleFormulario: (bool valor) {
          setState(() {
            _mostrando_formulario = valor;
          });
        },
      ),
    );
  }
}

class _PerfilView extends StatelessWidget {
  final bool mostrandoFormulario;
  final Function(bool) onToggleFormulario;

  const _PerfilView({
    required this.mostrandoFormulario,
    required this.onToggleFormulario,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF8F9FE),
      child: BlocBuilder<PerfilBloc, PerfilState>(
        builder: (context, state) {
          if (state is PerfilLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PerfilError) {
            return Center(
              child: Text(
                'Error al cargar datos: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is PerfilLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  if (!mostrandoFormulario) ...[
                    InformacionUsuarioWidget(
                      name: state.name,
                      role: state.role,
                      email: state.email,
                      memberSince: state.memberSince,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        onToggleFormulario(true);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar Perfil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C6BC0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ] else
                    FormularioEditar(
                      nombre: state.name,
                      email: state.email,
                      onSuccess: () {
                        context.read<PerfilBloc>().add(LoadPerfilData());
                        onToggleFormulario(false);
                      },
                      onCancel: () {
                        onToggleFormulario(false);
                      },
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}