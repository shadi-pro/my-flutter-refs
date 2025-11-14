/*  [homepage] =>
  this page wil include following tips:
   1-  Appbar =>  will be custom appbar       
   2-  
    

*/

import 'package:first_app/details.dart';
import 'package:flutter/material.dart';
// import '../widgets/custom_drawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // categories icons list   :
  List categories = [
    {"iconname": Icons.laptop, "title": "Laptop"},
    {"iconname": Icons.phone_android_outlined, "title": "Mobile"},
    {"iconname": Icons.electric_bike, "title": "Bike"},
    {"iconname": Icons.card_giftcard_outlined, "title": "Gifts"},
    {"iconname": Icons.electric_car_outlined, "title": "Cars"},
  ];

  // products [items]  icons list   :
  List items = [
    {
      "image": "assets/images/img1.jpg",
      "title": "product 1",
      'subtitle': 'product 1 description',
      "price": "350\$",
    },
    {
      "image": "assets/images/img2.jpg",
      "title": "product 2",
      'subtitle': 'product 2 description',
      "price": "200\$",
    },
    {
      "image": "assets/images/img3.jpg",
      "title": "product 3",
      'subtitle': 'product 3 description',
      "price": "400\$",
    },
    {
      "image": "assets/images/img1.jpg",
      "title": "product 4",
      'subtitle': 'product 4 description',
      "price": "100\$",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        selectedItemColor: Colors.orange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "home",
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //   Custom search box  section :
                Expanded(
                  // putting the TextFormField inside the expanded container to be able to expanded
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search ",
                      border:
                          //  [removing the deafult  border ]
                          InputBorder.none,
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.menu, size: 40),
                ),
              ],
            ),

            Container(height: 30),

            //  Categories title :
            Text(
              "Categories",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            Container(height: 10),

            //  Categories  icons sections  :
            Container(
              height: 100,
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: EdgeInsets.all(15),
                          child: Icon(categories[i]["iconname"], size: 40),
                        ),
                        Text(
                          categories[i]['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Products items  title:
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Best selling",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            // Products items section [dynamic] :
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 220, // increased height to fit content
              ),
              itemCount: items.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        // sending a defined  property 'items' with  property 'data' to sent with navigator :
                        builder: (context) => ItemsDetails(data: items[i]),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // prevents overflow
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Image.asset(
                            items[i]['image'],
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Text(items[i]['title']),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            items[i]['subtitle'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Text(
                            items[i]['price'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
