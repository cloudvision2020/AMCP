public inherited sharing class EthosCartTransformer {
  public EthosCart transform(String responseBody){
    try {

      EthosCart cart = new EthosCart();
      cart.cartItems = new List<EthosCart.CartItem>();
      Map<String, Object> rawBody = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
      List<Object> listOfCartItems = (List<Object>) rawBody.get('list');

      for(Object cartItemObj : listOfCartItems){
        String serializedCartItem = JSON.serialize(cartItemObj);
        EthosCart.CartItem cartItem =  (EthosCart.CartItem) JSON.deserialize(serializedCartItem, EthosCart.CartItem.class);
        cart.cartItems.add(cartItem);
      }
      return cart;

    } catch (Exception e) {
      EthosException.InvalidObjectFormatException formatException = new EthosException.InvalidObjectFormatException();
      formatException.setMessage(e.getMessage());
      throw formatException;
    }
  }
}