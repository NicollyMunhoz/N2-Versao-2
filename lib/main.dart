import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.collection('cardapio').doc('comidas').set({'Nome': 'Veggie tomato mix', 'Preco': 'N1,900', 'id': '1'});
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MyHomePage(),
      routes: {
        '/home': (context) => const SecondPage(),
      },
    );
  }
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              color: const Color(0xFFD44E36),
            ),
            Positioned(
              left: 20.0,
              top: 50.0,
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            const Positioned(
              left: 20,
              top: 170.0,
              right: 0,
              child: Center(
                child: Text(
                  'Food for Everyone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 300.0,
              right: 0,
              child: Image.network(
                'https://cdn.discordapp.com/attachments/1144320039579816068/1155621555615825950/Captura_de_tela_2023-09-24_183237-removebg-preview.png',
                width: 200,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 20.0,
              bottom: 20.0,
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.9,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.12,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            40.0), // Define o borderRadius como 40 pixels
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                          color: Color(0xFFD44E36),
                          fontSize: 19
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class QuintaPagina extends StatefulWidget {
  const QuintaPagina({super.key});

  @override
  _QuintaPaginaState createState() => _QuintaPaginaState();
}

class _QuintaPaginaState extends State<QuintaPagina> {
  Future<List<Widget>> listCarrinho() async {
    try {
      CollectionReference cardapioCollection = FirebaseFirestore.instance.collection('carrinho');
      QuerySnapshot querySnapshot = await cardapioCollection.get();

      List<Widget> items = [];

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (data.containsKey('Nome') && data.containsKey('Preco')) {
            String produto = data['Nome'];
            String preco = data['Preco'];

            items.add(
              Column(
                children: <Widget>[
                  Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                    child: SizedBox(
                      width: 300, // Defina a largura desejada
                      height: 150, // Defina a altura desejada
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AspectRatio(
                              aspectRatio: 1.0 / 1.0,
                              child: Image.network(
                                'https://cdn.discordapp.com/attachments/1144320039579816068/1155649798079262821/images-removebg-preview.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 50.0, 16.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    produto,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    preco,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFD44E36),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      } else {
        items.add(const Text('Carrinho vazio'));
      }

      return items;
    } catch (e) {
      return [Text('Erro ao buscar dados: $e')];
    }
  }

  // Função para limpar a coleção cardapio
  void clearCardapioCollection() {
    CollectionReference cardapioCollection = FirebaseFirestore.instance.collection('carrinho');

    // Obtém todos os documentos da coleção
    cardapioCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // Deleta cada documento individualmente
        doc.reference.delete();
      });
    }).catchError((error) {
      print('Erro ao limpar a coleção cardapio: $error');
    });
  }

  // Função para completar o pedido
  void completeOrder() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: 16.0,
              top: 40.0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/home');
                },
              ),
            ),
            const Positioned(
              top: 80.0,
              left: 16.0,
              right: 16.0,
              child: Text(
                'Cart',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              top: 150.0,
              right: 10.0,
              child: SizedBox(
                child: FutureBuilder<List<Widget>>(
                  future: listCarrinho(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Column(
                        children: snapshot.data ?? [],
                      );
                    }
                  },
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              bottom: 80.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    // Limpar a coleção cardapio
                    clearCardapioCollection();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuintaPagina()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black, // Cor da fonte
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    elevation: 0, // Remova a animação de seleção
                  ),
                  child: const Text(
                    'Limpar Cardapio',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              bottom: 20.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    // Completar o pedido
                    completeOrder();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFD44E36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),


                  ),
                  child: const Text(
                    'Complete Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuartaPagina extends StatefulWidget {
  const QuartaPagina({Key? key}) : super(key: key);

  @override
  _QuartaPaginaState createState() => _QuartaPaginaState();
}

class _QuartaPaginaState extends State<QuartaPagina> {
  String searchText = '';
  Widget resultWidget = Container();

  Future<void> readData() async {
    // Referência para a coleção 'cardapio'
    CollectionReference cardapioCollection = FirebaseFirestore.instance.collection('cardapio');

    // Referência para o documento 'comidas' dentro da coleção 'cardapio'
    DocumentReference comidasDocument = cardapioCollection.doc('comidas');

    // Obtém os dados do documento 'comidas'
    DocumentSnapshot documentSnapshot = await comidasDocument.get();

    if (documentSnapshot.exists) {
      // O documento existe, você pode acessar os dados
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      if (searchText.isEmpty || data['Nome'].toLowerCase() == searchText.toLowerCase()) {
        String nome = data['Nome'];
        String Preco = data['Preco'];

        // Atualize o widget de resultado com um botão
        setState(() {
          resultWidget = Center(
            child: Container(
              width: 250.0, // Largura desejada
              height: 250.0, // Altura desejada
              margin: EdgeInsets.only(top: 50, right: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40.0), // Border-radius de 40 pixels
                border: Border.all(
                  color: Colors.grey.shade300, // Cor da borda cinza
                  width: 1.0, // Largura da borda de 1 pixel
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://cdn.discordapp.com/attachments/1144320039579816068/1155649798079262821/images-removebg-preview.png',
                    fit: BoxFit.contain,
                    height: 150,
                    width: 150, // Ajustar a imagem ao container
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ThirdPage(),
                      ));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(0),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    child: Text('$nome', textAlign: TextAlign.center),
                  ),
                   Text(
                    '$Preco',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD44E36),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      } else {
        // Texto de pesquisa não corresponde ao documento
        setState(() {
          resultWidget = Center(
            child: Container(
              width: 350.0,
              height: 350.0,
              margin: EdgeInsets.only(top: 50.0),
              child: ElevatedButton(
                onPressed: () {
                  // Faça algo quando o botão for pressionado
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(0),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(
                      fontSize: 24.0, // Tamanho de fonte aumentado
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                child: const Text('Produto não encontrado'),
              ),
            ),
          );
        });
      }
    } else {
      // O documento 'comidas' não foi encontrado
      setState(() {
        resultWidget = Center(
          child: Container(
            width: 350.0,
            height: 350.0,
            margin: EdgeInsets.only(top: 50.0),
            child: ElevatedButton(
              onPressed: () {
                // Faça algo quando o botão for pressionado
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                elevation: MaterialStateProperty.all<double>(0),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(
                    fontSize: 24.0, // Tamanho de fonte aumentado
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: const Text('Produto não encontrado'),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: 5.0,
              top: 40.0,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/home');
                },
              ),
            ),
            Positioned(
              right: 16.0,
              top: 45.0,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: Icon(
                                Icons.search,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                            onChanged: (value) {
                              // Atualiza o texto de pesquisa quando o usuário digita
                              setState(() {
                                searchText = value;
                              });
                              readData();
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            readData();
                          },
                        ),
                      ],
                    ),
                  ),
                  // Exiba o resultado da pesquisa aqui
                  Center(child: resultWidget),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  Future<void> addToCardapio() async {
    final itemData = {
      'Nome': 'Veggie tomato mix',
      'Preco': 'N1,900',
      'id': '1',
    };

    try {
      await FirebaseFirestore.instance
          .collection('carrinho')
          .doc('prato')
          .set(itemData);
      print('Item adicionado ao cardapio com sucesso!');
    } catch (e) {
      print('Erro ao adicionar item ao cardapio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white, // Defina o fundo como branco
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Image.network(
              'https://cdn.discordapp.com/attachments/1144320039579816068/1155649798079262821/images-removebg-preview.png',
              fit: BoxFit.contain,
              height: 300,
              width: 300,
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.only(top: 0),
              child: const Text(
                'Veggie tomato mix',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Center(
            child: Container(
              padding: const EdgeInsets.only(top: 100.0),
              child: const Text(
                'N1,900',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD44E36),
                ),
              ),
            ),
          ),

          const Positioned(
            left: 30.0,
            bottom: 270.0,
            right: 80,
            child: Text(
              'Delivery info',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Positioned(
            left: 30.0,
            bottom: 170.0,
            right: 5,
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vestibulum justo eu fermentum.consectetur adipiscing elit. Sed vestibulum justo eu fermentum.Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),

          Positioned(
            left: 20.0,
            bottom: 20.0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.12,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    addToCardapio();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD44E36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  child: const Text(
                    'Add to cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 16.0,
            top: 40.0,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/home');
              },
            ),
          ),
        ],
      ),
    );
  }
}



class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      resizeToAvoidBottomInset: false,  // Define a barra de navegação como nula (removida)
      body: Stack(
        children: [
          Container(
            color: Colors.white, // Define a cor de fundo como branca
          ),
          const Positioned(
            left: 16.0, // Posição à esquerda
            top: 110.0, // Posição superior

            right: 80,
            child: Text(
              'Delicious food for you',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 16.0, // Posição à esquerda
            top: 40.0, // Posição superior

            child: IconButton(
              icon: const Icon(
                Icons.search,
                size: 30, // Define o tamanho do ícone como 20 pixels
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuartaPagina()),
                );
              },
            ),
          ),
          Positioned(
            right: 35.0,
            top: 250.0,

            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuartaPagina()),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(
                          Icons.search,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            right: 16.0, // Posição à esquerda
            top: 40.0, // Posição superior
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                size: 30, // Define o tamanho do ícone como 30 pixels
                color: Colors.grey, // Define a cor do ícone como cinza
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuintaPagina()),
                );
              },
            ),
          ),


          Positioned(
            left: 100.0, // Posição à direita
            bottom: 25.0, // Posição inferior
            child: IconButton(
              icon: const Icon(
                Icons.home,
                size: 30,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MyHomePage(),

                ));
              },
            ),
          ),


          Positioned(
            left: 150.0, // Posição à esquerda
            bottom: 25.0, // Posição inferior
            child: IconButton(
              icon: const Icon(
                Icons.favorite,
                size: 30,
                color: Colors.grey,
              ),
              onPressed: () {
                // Implemente a ação do ícone "heart" aqui
              },
            ),
          ),


          Positioned(
            left: 200.0, // Posição à esquerda
            bottom: 25.0, // Posição inferior
            child: IconButton(
              icon: const Icon(
                Icons.account_circle,
                size: 30,
                color: Colors.grey,
              ),
              onPressed: () {
                // Implemente a ação do ícone "account" aqui
              },
            ),
          ),




          Positioned(
            left: 250, // Posição à direita
            bottom: 25.0, // Posição inferior
            child: IconButton(
              icon: const Icon(
                Icons.history,
                size: 30,
                color: Colors.grey,
              ),
              onPressed: () {
                // Implemente a ação do ícone "history" aqui
              },
            ),
          ),




          Positioned(
            top: 310,
            left: 50,
            child: ElevatedButton(
              onPressed: () {
                // Ação a ser realizada quando o botão for pressionado
              },

              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                elevation: MaterialStateProperty.all<double>(0),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,), // Define o tamanho da fonte como 20 pixels
                ),
              ),

              child: const Text('Foods',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD44E36),
                ),
            ),
          ),
          ),






          Positioned(
            top: 310,
            left: 150,
            child: ElevatedButton(
              onPressed: () {
                // Ação a ser realizada quando o botão for pressionado
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                elevation: MaterialStateProperty.all<double>(0),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: const Text(
                'Drinks',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),




          Positioned(
            top: 310,
            left: 250,
            child: ElevatedButton(
              onPressed: () {
                // Ação a ser realizada quando o botão for pressionado
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                elevation: MaterialStateProperty.all<double>(0),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: const Text(
                'Snacks',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),



          Positioned(
            left: 0, // Posição à esquerda
            bottom: 120.0, // Posição no canto inferior
            right: 16.0, // Posição à direita
            child: CarouselSlider(
              items: [
                // Adicione os itens do seu carousel aqui

                Container(
                  width: 350.0, // Largura desejada
                  height: 350.0, // Altura desejada
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0), // Border-radius de 40 pixels
                    border: Border.all(
                      color: Colors.grey.shade300, // Cor da borda cinza
                      width: 1.0, // Largura da borda de 1 pixel
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://cdn.discordapp.com/attachments/1144320039579816068/1155649798079262821/images-removebg-preview.png',
                        fit: BoxFit.contain,
                        height: 150,
                        width: 150, // Ajustar a imagem ao container
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ThirdPage(),

                          ));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          elevation: MaterialStateProperty.all<double>(0),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,), // Define o tamanho da fonte como 20 pixels
                          ),
                        ),
                        child: const Text('Veggie tomato mix', textAlign: TextAlign.center),

                      ),
                      const Text('N1,900',
                          textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD44E36),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 350.0, // Largura desejada
                  height: 350.0, // Altura desejada
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0), // Border-radius de 40 pixels
                    border: Border.all(
                      color: Colors.grey.shade300, // Cor da borda cinza
                      width: 1.0, // Largura da borda de 1 pixel
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://cdn.discordapp.com/attachments/1144320039579816068/1155649798079262821/images-removebg-preview.png',
                        fit: BoxFit.contain,
                        height: 150,
                        width: 150, // Ajustar a imagem ao container
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ThirdPage(),

                          ));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          elevation: MaterialStateProperty.all<double>(0),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,), // Define o tamanho da fonte como 20 pixels
                          ),
                        ),
                        child: const Text('Veggie tomato mix', textAlign: TextAlign.center),

                      ),
                      const Text('N1,900',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD44E36),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
              options: CarouselOptions(
                height: 280.0,// Altura do carousel
                aspectRatio: 16 / 9, // Proporção de aspecto dos itens
                viewportFraction: 0.5, // Fração de visualização dos itens
                initialPage: 0, // Página inicial
                enableInfiniteScroll: false, // Rolagem infinita
                reverse: false, // Rolagem reversa
                autoPlay: false, // Reprodução automática
                autoPlayInterval: const Duration(seconds: 3), // Intervalo de reprodução automática
                autoPlayAnimationDuration: const Duration(milliseconds: 800), // Duração da animação de reprodução automática
                autoPlayCurve: Curves.fastOutSlowIn, // Curva de animação de reprodução automática
                enlargeCenterPage: true, // Ampliar a página central
                scrollDirection: Axis.horizontal, // Direção de rolagem (horizontal)
              ),
            ),
          ),
      ]
      ),
    );
  }
}