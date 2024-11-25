//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <cloud_firestore/cloud_firestore_plugin_c_api.h>
<<<<<<< HEAD
#include <firebase_auth/firebase_auth_plugin_c_api.h>
=======
>>>>>>> 113db3f6f509bcd7857f8e517e21228d736a736f
#include <firebase_core/firebase_core_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  CloudFirestorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("CloudFirestorePluginCApi"));
<<<<<<< HEAD
  FirebaseAuthPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseAuthPluginCApi"));
=======
>>>>>>> 113db3f6f509bcd7857f8e517e21228d736a736f
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
}
