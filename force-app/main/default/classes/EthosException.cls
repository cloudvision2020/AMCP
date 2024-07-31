public abstract class EthosException extends Exception {

  public class FailedApiCallException extends EthosException{}
  public class InvalidObjectFormatException extends EthosException{}
  public class UserNotFoundException extends EthosException{}
}