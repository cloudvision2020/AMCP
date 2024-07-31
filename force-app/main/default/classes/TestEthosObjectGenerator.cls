@IsTest
public class TestEthosObjectGenerator {

  public static EthosCart generateCartWithOneItem(){
    String nodeId = 'NODE_ID';
    return generateCartWithOneItem(nodeId);
  }

  public static EthosCart generateCartWithOneItem(String nodeId) {
    EthosCart cart = new EthosCart();
    cart.cartItems = new List<EthosCart.CartItem>();

    EthosCart.CartItem cartItem = new EthosCart.CartItem();
    cartItem.cart_item_id = 'CART_ITEM_ID';
    cartItem.cart_id = 'CART_ID';
    cartItem.nid = nodeId;
    cartItem.qty = 1;

    cart.cartItems.add(cartItem);

    return cart;
  }

}