import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hadal/pacientes/procedimientoServicios/calendarioAgregar.dart';
import 'package:hadal/pacientes/procedimientoServicios/calendarioUrgente.dart';

class Servicios {
  String nombre;
  String icono;
  double total;
  String domicilio;
  String tipoCategoria;
  GeoPoint ubicacion;

  Servicios({
    required this.nombre,
    required this.icono,
    required this.total,
    required this.domicilio,
    required this.ubicacion,
    required this.tipoCategoria,
  });
}

class Descripcion extends StatefulWidget {
  final dynamic servicio;

  Descripcion({required this.servicio});

  @override
  _DescripcionState createState() => _DescripcionState();
}

class _DescripcionState extends State<Descripcion> {
  List<Servicios> _servicios = [];
  double _total = 0.0;
  double _costoServicio = 0.0;
  late String _domicilio = "";
  late GeoPoint _ubicacion;

  Future<void> initializeAppAndGetName() async {
    await Firebase.initializeApp();
    final currentUser = FirebaseAuth.instance.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('usuariopaciente')
        .doc(currentUser!.uid)
        .get();
    setState(() {
      _domicilio = userDoc['domicilio'] ?? "";
      _ubicacion = userDoc['ubicacion'] ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    initializeAppAndGetName();
  }

  @override
  Widget build(BuildContext context) {
    _costoServicio = double.parse(widget.servicio['precio']) * .05;
    _total = double.parse(widget.servicio['precio']) + _costoServicio;

    return Scaffold(
      backgroundColor: Color(0xFFF4FCFB),
      appBar: AppBar(
        backgroundColor: Color(0xFFF4FCFB),
        title: Text(
          'Agregar servicio',
          style: TextStyle(
            color: Color(0xFF235365),
            fontSize: 20,
          ),
        ),
        toolbarHeight: kToolbarHeight - 10,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF235365),
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        elevation: 2.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.network(
                          widget.servicio['icono'],
                          width: 40,
                          height: 40,
                          color: Color(0xFF245366),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                              Text(
                                widget.servicio['procedimiento'],
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF245366)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // Espacio para separar
                    Text(
                      'Domicilio:',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF245366)),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF1FBAAF)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 16.0, color: Color(0xFF245366)),
                            text: '$_domicilio',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Descripción:',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF245366)),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF1FBAAF)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 16.0, color: Color(0xFF245366)),
                            text: widget.servicio['descripcion'],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Tiempo:',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF245366)),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${widget.servicio['tiempo']}',
                          style: TextStyle(
                              fontSize: 20.0, color: Color(0xFF245366)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF1FBAAF)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Precio: \$${double.parse(widget.servicio['precio']).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF245366), // Color del texto
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Costo de servicio (5%): \$${_costoServicio.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF245366), // Color del texto
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Total: \$$_total',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF245366), // Color del texto
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Color(0xFFF4FCFB),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Servicios servicio = Servicios(
                            nombre: widget.servicio['procedimiento'],
                            icono: widget.servicio['icono'],
                            total: _total,
                            domicilio: _domicilio,
                            ubicacion: _ubicacion,
                            tipoCategoria: widget.servicio['tipoCategoria'],
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CalendarioAgregar(servicio: servicio),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: Color(0xFF1FBAAF),
                          minimumSize: Size(135, 50.0),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Agregar'),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Servicios servicio = Servicios(
                            nombre: widget.servicio['procedimiento'],
                            icono: widget.servicio['icono'],
                            total: _total,
                            domicilio: _domicilio,
                            ubicacion: _ubicacion,
                            tipoCategoria: widget.servicio['tipoCategoria'],
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CalendarioUrgente(servicio: servicio),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: Color(0xFF1FBAAF),
                          minimumSize: Size(135, 50.0),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Urgente'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
