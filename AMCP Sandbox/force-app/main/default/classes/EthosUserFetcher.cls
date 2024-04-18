public inherited sharing class EthosUserFetcher {

  public EthosUser retrieveSingleUser(String responseBody) {
    return retrieveMultipleUsers(responseBody)[0];
  }

  public List<EthosUser> retrieveMultipleUsers(String responseBody) {
    List<EthosUser> ethosUsers = new List<EthosUser>();
    try {
      Map<String, Object> rawBody = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
      List<Object> listOfUsers = (List<Object>) rawBody.get('list');
      if (listOfUsers.isEmpty() == false) {
        for (Object objectUser : listOfUsers) {
          String serializedUser = JSON.serialize(objectUser);
          EthosUser ethosUser = (EthosUser) JSON.deserialize(serializedUser, EthosUser.class);
          ethosUsers.add(ethosUser);
        }
        return ethosUsers;
      } else {
        throw new EthosException.UserNotFoundException();
      }

    } catch (EthosException.UserNotFoundException e) {
      throw e;
    } catch (Exception e) {
      EthosException.InvalidObjectFormatException formatException = new EthosException.InvalidObjectFormatException();
      formatException.setMessage(e.getMessage());
      throw formatException;
    }
  }

}