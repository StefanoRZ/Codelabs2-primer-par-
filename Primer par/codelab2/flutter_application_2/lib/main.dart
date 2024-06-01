import 'package:flutter/material.dart';

void main(){
  runApp(
    AppStateWidget(
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Store',
       home: MyStorePage(),
     )
    ),
  );
}

class AppState{
AppState({
  required this.productList,
  this.itemsInCart = const <String>{},
});
final List<String> productList;
final Set<String> itemsInCart;

  AppState copyWith({
 List<String>? productList,
 Set<String>? itemsInCart,

  }){
   return AppState(
    productList: productList ?? this.productList,
    itemsInCart: itemsInCart ?? this.itemsInCart,
   );
  }
}

class AppStateScope extends InheritedWidget{
   AppStateScope(
   this.data,{
     Key? key, 
     required Widget child,
  }) : super(key:key, child: child);



   final AppState data; 

   static AppState of(BuildContext context){
     return context.dependOnInheritedWidgetOfExactType <AppStateScope>()!.data;
  }
  @override
  bool updateShouldNotify(AppStateScope oldWidget){

   return data != oldWidget.data; 
  }
}

class AppStateWidget extends StatefulWidget{
  AppStateWidget({required this.child});

  final Widget child;

  static AppStateWidgetState of(BuildContext context) {
      return context.findAncestorStateOfType<AppStateWidgetState>()!;
  }
  @override
  AppStateWidgetState createState() => AppStateWidgetState();
  }

  class AppStateWidgetState extends State<AppStateWidget>{
    AppState _data = AppState(
      productList: Server.getProductList(),
    );

    void setProductList(List<String> newProductList) {
       if (_data.productList != newProductList) {
         setState(() {
           _data = _data.copyWith(productList: newProductList);
         });
       }
    }
    void addToCart(String id) {
       if (!_data.itemsInCart.contains(id)) {
         setState(() {
          final Set<String> newItemsInCart = 
           Set<String>.from(_data.itemsInCart);
           newItemsInCart.add(id);
           _data = _data.copyWith(itemsInCart: newItemsInCart);
         });
       }
    }
    void removeFromCart(String id) {
        if (!_data.itemsInCart.contains(id)) {
         setState(() {
          final Set<String> newItemsInCart = 
           Set<String>.from(_data.itemsInCart);
           newItemsInCart.remove(id);
           _data = _data.copyWith(itemsInCart: newItemsInCart);
         });
       }
    }
    @override
    Widget build(BuildContext context) {
      return AppStateScope(_data, 
      child: widget.child,
          );
    }
  }
class MyStorePage extends StatefulWidget {
  MyStorePage({Key? key}) : super(key:key);

  @override
    MyStorePageState createState() => MyStorePageState();
}

class MyStorePageState extends State<MyStorePage>{

  bool _inSearch = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  void _toggleSearch(){
  setState((){
    _inSearch = !_inSearch;
  });

  _controller.clear();

  AppStateWidget.of(context).setProductList(Server.getProductList());
}

void _handleSearch() { 
  _focusNode.unfocus();
  final String filter = _controller.text;

    AppStateWidget.of(context).setProductList(Server.getProductList(filter: 
    filter));
}

@override
Widget build(BuildContext context){
  return Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: Padding(
            padding: EdgeInsets.all(16.0),
            child: Image.network('$baseAssetURL/google-logo.png')
          ),
          title: _inSearch
          ? TextField(
            autofocus: true,
            focusNode: _focusNode,
            controller: _controller,
            onSubmitted: (_) => _handleSearch(),
            decoration: InputDecoration(
              hintText: 'Search Google Store',
              prefixIcon: IconButton(icon: Icon(Icons.search),
  onPressed: _handleSearch),
               suffixIcon: IconButton(icon: Icon(Icons.close),
  onPressed: _toggleSearch),          
            )
          )
          :null,
          actions: [
            if(!_inSearch) IconButton(onPressed: _toggleSearch, icon:
  Icon(Icons.search, color: Colors.black)),
                ShoppingCartIcon(),
          ],
           backgroundColor: Colors.white,
           pinned: true,
          ),
          SliverToBoxAdapter(
            child: ProductListWidget(),
          ),
       ],
      ),
    );
  }
}

class ShoppingCartIcon extends StatelessWidget{
  ShoppingCartIcon({Key? key}) : super(key:key);

  @override
Widget build(BuildContext context){
  final Set<String> itemsInCart = AppStateScope.of(context).itemsInCart;
  final bool hasPurchase = itemsInCart.length > 0;
  return Stack(
    alignment: Alignment.center,
    children: [
      Padding(
        padding: EdgeInsets.only(right: hasPurchase ? 17.0 : 10.0),
        child: Icon(
          Icons.shopping_cart,
          color: Colors.black,
        ),
      ),
       if(hasPurchase)
       Padding(
        padding: const EdgeInsets.only(left:17.0),
        child:CircleAvatar(
          radius: 8.0,
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          child: Text(
            itemsInCart.length.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    ],
  );
 }
}
class ProductListWidget extends StatelessWidget{
  ProductListWidget({Key? key}) : super(key:key);

  void _handleAddToCart(String id, BuildContext context){
    AppStateWidget.of(context).addToCart(id);
  }

   void _handleRemoveFromCart(String id, BuildContext context){
   AppStateWidget.of(context).removeFromCart(id);
  }

  Widget _buildProductTile(String id, BuildContext context){
    return ProductTile(
      product: Server.getProductById(id),
      purchased: AppStateScope.of(context).itemsInCart.contains(id),
      onAddtoCart: () => _handleAddToCart(id, context),
      onRemoveFromCart: () => _handleRemoveFromCart(id, context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: AppStateScope.of(context)
      .productList.map(
        (String id)=> _buildProductTile(id, context),
        ).toList(),
    );
  }
} 
class ProductTile extends StatelessWidget{
    ProductTile({
      Key? key,
      required this.product,
      required this.purchased,
      required this.onAddtoCart,
      required this.onRemoveFromCart,
    }) ; super(key : key);
    final Product product;
    final bool purchased;
    final VoidCallback onAddtoCart;
    final VoidCallback onRemoveFromCart;

    @override
    Widget build(BuildContext context) {
      Color getButtonColor(Set<MaterialState> states){
        return purchased ? Colors.grey : Colors.black;
      }
      return Container(
        margin: EdgeInsets.symmetric(
          vertical: 15,
          )
      );
    }

  }