import 'package:alhaji_user_app/models/cart.dart';
import 'package:alhaji_user_app/provider/search-filter.dart';
import 'package:alhaji_user_app/provider/session.dart';
import 'package:alhaji_user_app/utils/commons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  SearchFilterProvider searchFilterProvider;
  SessionProvider sessionProvider;

  @override
  Widget build(BuildContext context) {
    searchFilterProvider = Provider.of<SearchFilterProvider>(context);
    sessionProvider = Provider.of<SessionProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            topBar(),
            Container(
              constraints: BoxConstraints(maxWidth: 650),
              child: Column(
                children: [
                  titleCard('Menu'),
                  toggleButton(),
                  titleCard('Sort by'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buttonCard('Rating',
                            value: searchFilterProvider.sortBy == SORTBY.RATING, sortBy: SORTBY.RATING),
                        buttonCard('Price', value: searchFilterProvider.sortBy == SORTBY.PRICE, sortBy: SORTBY.PRICE),
                        buttonCard('Quantity',
                            value: searchFilterProvider.sortBy == SORTBY.QUNANTITY, sortBy: SORTBY.QUNANTITY),
                      ],
                    ),
                  ),
                  titleCard('Rating'),
                  ratingCard(),
                  rangeSelector(),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              // changeIndex(1);
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.all(3),
                              // constraints: BoxConstraints(maxWidth: 290),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Commons.greyAccent3,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                'Reset',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () async {
                              searchFilterProvider.applyProducts(
                                  sessionProvider.bearer, sessionProvider.currentBranch.branchCode);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.all(3),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Commons.bgColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                'Apply',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ratingCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          for (int i = 1; i <= 5; i++)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  searchFilterProvider.changeRating(i);
                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    margin: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: searchFilterProvider.rating == i ? Commons.bgColor : Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.07), blurRadius: 4, spreadRadius: 4, offset: Offset(2, 2))
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(i.toString() + ' ',
                            style: TextStyle(
                                color: searchFilterProvider.rating == i ? Colors.white : Commons.textColor,
                                fontSize: 12)),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Icon(Icons.star,
                                color: searchFilterProvider.rating == i ? Colors.white : Colors.grey, size: 14)),
                      ],
                    )),
              ),
            ),
        ],
      ),
    );
  }

  Widget rangeSelector() {
    return Column(children: [
      Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Price Range', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
                '£${searchFilterProvider.rangeValues.start.round()} - £${searchFilterProvider.rangeValues.end.round()}',
                style: TextStyle(color: Commons.greyAccent3, fontSize: 16, fontWeight: FontWeight.bold))
          ])),
      RangeSlider(
          values: searchFilterProvider.rangeValues,
          min: 0,
          max: 500,
          labels: RangeLabels(searchFilterProvider.rangeValues.start.round().toString(),
              searchFilterProvider.rangeValues.end.round().toString()),
          onChanged: (RangeValues values) {
            searchFilterProvider.changeRange(values);
          })
    ]);
  }

  Widget titleCard(String title) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
  }

  Widget buttonCard(String title, {bool value = false, SORTBY sortBy}) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          searchFilterProvider.changeSortBy(sortBy);
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            margin: EdgeInsets.all(2),
            // width: MediaQuery.of(context).size.width / 3 - 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: value ? Commons.bgColor : Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(.07), blurRadius: 4, spreadRadius: 4, offset: Offset(2, 2))
                ]),
            child: Text(title,
                style: TextStyle(
                    color: value ? Colors.white : Commons.textColor, fontSize: 12, fontWeight: FontWeight.w600))),
      ),
    );
  }

  Widget topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(.11), blurRadius: 2, spreadRadius: 1, offset: Offset(5, 2))
                ]),
                child: Icon(Icons.arrow_back_ios_rounded, size: 20, color: Colors.black))),
        Text('Filter', style: TextStyle(color: Commons.textColor, fontSize: 18, fontWeight: FontWeight.w600)),
        Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.all(5),
        ),
      ]),
    );
  }

  Widget toggleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.all(2),
        constraints: BoxConstraints(maxWidth: 600),
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100), border: Border.all(width: .2)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                searchFilterProvider.changeProductType(PRODUCTTYPE.COMBO);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2 - 20,
                constraints: BoxConstraints(maxWidth: 290),
                padding: EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: searchFilterProvider.menu == PRODUCTTYPE.COMBO ? Commons.bgColor : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text('Meals',
                    style: TextStyle(
                        color: searchFilterProvider.menu == PRODUCTTYPE.COMBO ? Colors.white : Colors.black,
                        fontSize: 16)),
              ),
            ),
            GestureDetector(
              onTap: () {
                searchFilterProvider.changeProductType(PRODUCTTYPE.PRODUCT);
              },
              child: Container(
                padding: EdgeInsets.all(15),
                constraints: BoxConstraints(maxWidth: 290),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2 - 20,
                decoration: BoxDecoration(
                  color: searchFilterProvider.menu == PRODUCTTYPE.PRODUCT ? Commons.bgColor : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Dishes',
                  style: TextStyle(
                      color: searchFilterProvider.menu == PRODUCTTYPE.PRODUCT ? Colors.white : Colors.black,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
