/*
 * Created by ashwinireddy on 4/30/23.
 */

import { LightningElement } from 'lwc';
import userId from "@salesforce/user/Id";
import isGuest from "@salesforce/user/isGuest";
import communityId from "@salesforce/community/Id";
import syncUserProfilePhotoAction from "@salesforce/apex/UserProfilePhotoSyncController.syncUserProfilePhoto";

export default class CommunityUserProfilePhotoSync extends LightningElement {
  connectedCallback() {
    if (!isGuest) {
      this.syncUserProfilePhoto();
    }
  }

  syncUserProfilePhoto() {
    try {
      syncUserProfilePhotoAction({ userId, communityId });
    } catch (e) {
      console.log(e);
    }
  }
}