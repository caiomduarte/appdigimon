import 'dart:convert';

import 'package:appdigimon/model/Digimon.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Metodo que lista os Digimons
  void ListarDigimons() async {
    //1 Passo - definir a url da api
    var url = Uri.parse("https://digimon-api.vercel.app/api/digimon");
    http.Response response = await http.get(url);

    print("Resposta da API: " + response.body.toString());
  }

  Future<List<Digimon>> _recuperarDigimons() async {
    try {
      List<Digimon> lista = List.empty(growable: true);

      var url = Uri.parse("https://digimon-api.vercel.app/api/digimon");

      http.Response response = await http.get(url);

      var dadosJson = json.decode(response.body);

      for (var item in dadosJson) {
        print(item["name"]);
        print(item["level"]);
        Digimon obj = Digimon(item["name"], item["img"], item["level"]);

        lista.add(obj);
      }

      return lista;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Consumindo uma API REST"),
          backgroundColor: Colors.blueAccent,
        ),
        body: FutureBuilder<List<Digimon>>(
            future: _recuperarDigimons(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:

                case ConnectionState.waiting:
                  //print("Conexao waiting");
                  return CircularProgressIndicator();

                case ConnectionState.active:
                  break;

                case ConnectionState.done:
                  print("conexao done");

                  if (snapshot.hasError) {
                    print("lista: Erro ao Carregar");
                  } else {
                    //Carrega a lista

                    print("lista carregou");

                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 10),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          List<Digimon>? digimons = snapshot.data;
                          Digimon digimon = digimons![index];

                          return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      digimon.img,
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                  Text(digimon.name),
                                ],
                              ));
                        });
                  }

                  break;
              }
              return Text("Não foi possivel exibir a lista!");
            }));
  }
}
