package com.rn.s.baidumap;

import android.os.Looper;

import com.rn.s.baidumap.mapview.BaiduMapViewManager;
import com.rn.s.baidumap.mapview.OverlayArcManager;
import com.rn.s.baidumap.mapview.OverlayCircleManager;
import com.rn.s.baidumap.mapview.OverlayMarkerManager;
import com.rn.s.baidumap.mapview.OverlayPolygonManager;
import com.rn.s.baidumap.mapview.OverlayPolylineManager;
import com.rn.s.baidumap.modules.BaiduMapSearchModule;
import com.rn.s.baidumap.modules.GeolocationModule;
import com.baidu.mapapi.SDKInitializer;
import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.rn.s.baidumap.modules.OfflineMapModule;
import com.rn.s.baidumap.modules.RoutePlanSearchModule;

import java.util.Arrays;
import java.util.List;

import androidx.annotation.MainThread;

/**
 * Created by sujialong on 2019/7/8.
 */

public class BaiduMapPackage implements ReactPackage {

    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        init(reactContext);
        return Arrays.<NativeModule>asList(
            new GeolocationModule(reactContext),
            new BaiduMapSearchModule(reactContext),
            new RoutePlanSearchModule(reactContext),
            new OfflineMapModule(reactContext)
        );
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Arrays.<ViewManager>asList(
            new BaiduMapViewManager(),
            new OverlayMarkerManager(),
            new OverlayPolylineManager(),
            new OverlayArcManager(),
            new OverlayCircleManager(),
            new OverlayPolygonManager()
        );
    }

    @MainThread
    protected void init(ReactApplicationContext reactContext) {
        Looper.prepare();
        SDKInitializer.initialize(reactContext.getApplicationContext());
    }
}
