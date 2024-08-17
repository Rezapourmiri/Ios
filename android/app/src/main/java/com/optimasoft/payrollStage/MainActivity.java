package com.optimasoft.payrollStage;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.BinaryMessenger;
import android.provider.Settings;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.ComponentName;
import java.util.*;
import android.content.pm.ResolveInfo;
import android.util.Log;
import com.judemanutd.autostarter.AutoStartPermissionHelper;
import android.app.AppOpsManager;
import java.lang.reflect.InvocationTargetException;    
import java.lang.reflect.Method;  

import android.app.Activity;
import android.content.pm.PackageInfo;
import android.preference.PreferenceActivity;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "activity/optima_soft";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
            (call, result) -> {
                // This method is invoked on the main thread.
                if (call.method.equals("getBatteryLevel")) {
                  int batteryLevel = getBatteryLevel();
    
                  if (batteryLevel != -1) {
                    result.success(batteryLevel);
                  } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null);
                  }
                } 
                else if(call.method.equals("permit-auto-start")){
                  addAutoStartup(result);
                } 
                else if(call.method.equals("goToXiaomiOtherPermissions")){
                  // isShowOnLockScreenPermissionEnable();
                  goToXiaomiOtherPermissions();
                  result.success("Success");
                } 
                else  if (call.method.equals("isAutoStartPermission")) {
                  result.success(AutoStartPermissionHelper.getInstance().isAutoStartPermissionAvailable(getApplicationContext()));
                }
                else if (call.method.equals("customSetComponent")) {
                  String manufacturer = call.argument("manufacturer");
                  String pkg = call.argument("pkg");
                  String cls = call.argument("cls");
                  customSetComponent(manufacturer,pkg,cls,result);
                  result.success("Success");
                }
                else {
                  result.notImplemented();
                }
              }
        );
  }

  private int getBatteryLevel() {
    int batteryLevel = -1;
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
          registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
          intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }

    return batteryLevel;
  }

  
  private void customSetComponent(String manufacturer, String pkg, String cls,@NonNull Result result){
    String systemManufacturer = android.os.Build.MANUFACTURER;
    try {
      Intent intent = new Intent();
      if (manufacturer.equalsIgnoreCase(systemManufacturer)) {
        intent.setComponent(new ComponentName(pkg, cls));
      }
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      startActivity(intent);
    }catch (Exception e){
      result.error("Failed",e.toString(),"");
    }
  }
  
  private void goToXiaomiOtherPermissions() {
    try {
      String manufacturer = android.os.Build.MANUFACTURER;
      if ("xiaomi".equalsIgnoreCase(manufacturer)) {
        Intent intent = new Intent("miui.intent.action.APP_PERM_EDITOR");
        intent.setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity"); 
        intent.putExtra("extra_pkgname", getPackageName()); 
        startActivity(intent);
      }
    } catch (Exception e) {
      Log.e("exc" , String.valueOf(e));
    }
  }

  
  
  private void isShowOnLockScreenPermissionEnable() {
    try {
        
      try {
        final int version = android.os.Build.VERSION.SDK_INT;
        if (version >= 19) {
          AppOpsManager mAppOps = (AppOpsManager) getSystemService(APP_OPS_SERVICE);

          PackageManager mPm = getPackageManager();
          PackageInfo mPackageInfo = null;
          try {
              mPackageInfo = mPm.getPackageInfo(getPackageName(),
                      PackageManager.GET_DISABLED_COMPONENTS | PackageManager.GET_UNINSTALLED_PACKAGES);
          } catch (Exception e) {
          }
          Log.e("exc" ,"1");
          int permission = mAppOps.noteOp(AppOpsManager.OPSTR_COARSE_LOCATION, mPackageInfo.applicationInfo.uid,
                mPackageInfo.packageName);
                Log.e("exc" ,"2");
          // Class clazz = AppOpsManager.class;
          // Method method = clazz.getDeclaredMethod("checkOpNoThrow", int.class, int.class, String.class);
          // method.invoke(manager, 10020, Binder.getCallingUid(), getPackageName());
        }
      } catch (Exception e) {
          Log.e("exc" , String.valueOf(e));
      }
  

    //   final int version = Build.VERSION.SDK_INT;
    // if (version >= 19) {
    //     AppOpsManager manager = (AppOpsManager) getSystemService(APP_OPS_SERVICE);
    //     try {
    //         Class clazz = AppOpsManager.class;
    //         Method method = clazz.getDeclaredMethod("checkOp", int.class, int.class, String.class);
    //         return AppOpsManager.MODE_ALLOWED == (int)method.invoke(manager, op, Binder.getCallingUid(), getPackageName());
    //     } catch (Exception e) {
    //         Log.e(TAG, Log.getStackTraceString(e));
    //     }
    // } else {
    //     Log.e(TAG, "Below API 19 cannot invoke!");
    // }
      
      // AppOpsManager manager = getSystemService(APP_OPS_SERVICE);
      // Method method = class.java.getDeclaredMethod(
      //       "checkOpNoThrow",
      //       int,int,String
      //   );
      //   int result = method.invoke(manager, 10020, Binder.getCallingUid(), context.packageName);
      //   AppOpsManager.MODE_ALLOWED == result;
      // int batteryLevel = -1;
      
      // PowerManager powerManager = getSystemService(POWER_SERVICE);
			// 	return powerManager.isIgnoringBatteryOptimizations(getPackageName());
    } catch (Exception e) {
      Log.e("exc" , String.valueOf(e));
    }
  }
  

  private void addAutoStartup(@NonNull Result result) {
    try {
      Intent intent = new Intent();
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      String manufacturer = android.os.Build.MANUFACTURER;
      if ("xiaomi".equalsIgnoreCase(manufacturer)) {
        intent.setComponent(new ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity"));
      } else if ("oppo".equalsIgnoreCase(manufacturer)) {
        intent.setComponent(new ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity"));
      } else if ("vivo".equalsIgnoreCase(manufacturer)) {
        intent.setComponent(new ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity"));
      } else if ("Letv".equalsIgnoreCase(manufacturer)) {
        intent.setComponent(new ComponentName("com.letv.android.letvsafe", "com.letv.android.letvsafe.AutobootManageActivity"));
      } else if ("Honor".equalsIgnoreCase(manufacturer)) {
        intent.setComponent(new ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.optimize.process.ProtectActivity"));
      }else if ("samsung".equalsIgnoreCase(manufacturer)) {
        intent.setComponent(new ComponentName("com.samsung.android.lool", "com.samsung.android.sm.battery.ui.BatteryActivity"));
      }else if ("oneplus".equalsIgnoreCase(manufacturer)) {
        intent.setComponent(new ComponentName("com.oneplus.security", "com.oneplus.security.chainlaunch.view.ChainLaunchAppListActivity"));
      }else if ("nokia".equalsIgnoreCase(manufacturer)) {
        intent.setComponent(new ComponentName("com.evenwell.powersaving.g3", "com.evenwell.powersaving.g3.exception.PowerSaverExceptionActivity"));
      }else if ("asus".equalsIgnoreCase(manufacturer)) {
        intent.setComponent(new ComponentName("com.asus.mobilemanager", "com.asus.mobilemanager.autostart.AutoStartActivy"));
      } else if ("realme".equalsIgnoreCase(manufacturer)) {
        intent.setAction(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS);
      }
      List<ResolveInfo> list = getPackageManager().queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);
      if  (list.size() > 0) {
        startActivity(intent);
      }
      result.success("Success");
    } catch (Exception e) {
      Log.e("exc" , String.valueOf(e));
    }
  }
}