import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopy/main.dart';
import 'package:shopy/model/language/language_constants.dart';
import 'package:shopy/services/product_service.dart';
import 'package:shopy/view/add_product_page.dart';
import 'package:shopy/view/detail_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../model/language/language.dart';


class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  bool isFab = true;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLng();
  }

  String? selectedLanguage;
  void getLng()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode') ?? 'English';
    print(languageCode);
    setState(() {
      if(languageCode=='ne'){
        selectedLanguage = '🇳🇵';
      }else{
        selectedLanguage = '🇺🇸';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productData = ref.watch(getProduct);
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).productList,),
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.grey
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: PopupMenuButton<Language>(
                itemBuilder: (context){
                  return Language.languageList().map((e) =>
                  PopupMenuItem<Language>(
                    value: e,
                    child: Row(
                      children: [
                        Text(e.flag),
                        Text(e.name),
                      ]),
                  )).toList();
                },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${translation(context).language} :',
                    style: TextStyle(fontSize: translation(context).language == 'Language' ? 10.sp : 12.sp),),
                  Text('$selectedLanguage', style: TextStyle(fontSize: 16.sp),),
                ],
              ),
              onSelected: (Language? language)async{
                  if(language!= null){
                    selectedLanguage = language.flag;
                    Locale _locale = await setLocale(language.languageCode);
                    MyApp.setLocale(context, _locale);
                  }
                  },
            ),
          )

          // Padding(
          //   padding: const EdgeInsets.only(right:16.0),
          //   child: DropdownButton<Language>(
          //     hint: Text('$selectedLanguage', style: TextStyle(color: Colors.white),),
          //     // underline: const SizedBox(),
          //     icon: const Icon(Icons.language),
          //       items: Language.languageList().map((e) =>
          //       DropdownMenuItem<Language>(
          //         value: e,
          //           child: Row(
          //             children: [
          //               Text(e.flag),
          //               Text(e.name),
          //             ],
          //           ),
          //       )
          //       ).toList(),
          //       onChanged: (Language? language)async{
          //       if(language!= null){
          //         selectedLanguage = language.flag;
          //         Locale _locale = await setLocale(language.languageCode);
          //         MyApp.setLocale(context, _locale);
          //       }
          //       }),
          // )
        ],
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification){
          if(notification.direction == ScrollDirection.forward){
            if(!isFab) setState(() { isFab = true; });
          }else if(notification.direction == ScrollDirection.reverse){
            if(isFab) setState(() { isFab = false; });
          }
          return true;
        },
        child: productData.when(
            data: (data){
              return RefreshIndicator(
                onRefresh: () async{
                 return ref.refresh(getProduct);
                },
                child: data.isEmpty ? const Center(child: Text('Product List is empty'),)
                    : ListView.builder(
                    key: const PageStorageKey<String>('page'),
                    itemCount: data.length,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                        child: InkWell(
                          onTap: (){
                            Get.to(()=> DetailPage(product: data[index]), transition: Transition.rightToLeft);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.grey,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150.w,
                                  height: 100.h,
                                  decoration: const BoxDecoration(
                                  color: Colors.black,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))
                                  ),
                                  child: Hero(
                                      tag: 'image-${data[index].id}',
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
                                        child: Image.network(data[index].image, fit: BoxFit.cover,))),
                                ),
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.all(6.0),
                                    width: MediaQuery.of(context).size.width,
                                    height: 100.h,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text(data[index].product_name,style: TextStyle(fontSize: 16.sp),),
                                           Text(data[index].product_detail,
                                             maxLines: 4, textAlign: TextAlign.left,
                                             style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 14.sp ),
                                           ),
                                         ],
                                       ),
                                        Text('${translation(context).rs} ${data[index].price.toString()}'),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                }),
              );
            },
            error: (error, stack)=>Center(child: Text('$error'),),
            loading: ()=> SpinKitWave(color: Colors.white,size: 24,)),
      ),
      floatingActionButton: isFab ? FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.black,
        extendedPadding: EdgeInsets.symmetric(horizontal: 8.0),
        onPressed: (){
          Get.to(()=> CreateProduct(), transition: Transition.rightToLeftWithFade);
        },
        label: Text(AppLocalizations.of(context)!.addProduct, style: TextStyle(color: Colors.white, letterSpacing: 0),),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            // side: BorderSide(color: Colors.white, width: 0.5)
        ),

      ): null,
    );
  }
}
