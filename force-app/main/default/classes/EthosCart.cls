public inherited sharing class EthosCart {
  public List<CartItem> cartItems;
  public class CartItem{
    public String cart_item_id;
    public String cart_id;
    public String nid;
    public Integer qty;
    public String changed;
    public Node node;
  }

  public class Node {
    public String uri;
    public String id;
    public String resource;
    public String uuid;
  }

}