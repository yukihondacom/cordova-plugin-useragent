package im.ltdev.cordova;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.webkit.WebSettings;
import android.webkit.WebView;

import android.os.Bundle;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.PreferenceManager;
import android.content.Context;

public class UserAgent extends CordovaPlugin {

        public WebSettings settings;

        @Override
        public void initialize(CordovaInterface cordova, CordovaWebView webView) {

            super.initialize(cordova, webView);

            try{

                settings = ((WebView) webView.getEngine().getView()).getSettings();

            }catch (Exception error){

                settings = null;

            }
        }

        @Override
        public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
               try {
                  if (action.equals("set")) {
                     String text = args.getString(0);
                     // インスタンスを取得する
                     SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(cordova.getActivity());
                     // データを保存する
                     sp.edit().putString("UserAgent", text).commit();
                     settings.setUserAgentString(text);
                     callbackContext.success(settings.getUserAgentString());
                     return true;
                   } else if (action.equals("get")) {
                     callbackContext.success(settings.getUserAgentString());
                     return true;
                   } else if (action.equals("reset")) {
                     settings.setUserAgentString(null);
                     callbackContext.success(settings.getUserAgentString());
                     return true;
                  }
                  callbackContext.error("Invalid action");
                  return false;
                } catch (Exception e) {
                  callbackContext.error(e.getMessage());
                  return false;
               }
	}

}
