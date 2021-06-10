package com.example.doclense;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;

import androidx.annotation.NonNull;

import org.opencv.android.OpenCVLoader;
import org.opencv.android.Utils;
import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.MatOfByte;
import org.opencv.core.Point;
import org.opencv.core.Size;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

import java.io.ByteArrayOutputStream;
import java.io.File;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    byte[] originalArray;
    
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),"opencv").setMethodCallHandler((call, result) -> {

            if(call.method.equals("original")){
                System.out.println("original");
                Bitmap bitmap= BitmapFactory.decodeFile(call.argument("filePath").toString());
                int height=bitmap.getHeight();
                int width=bitmap.getWidth();
                double tl_x=call.argument("tl_x");
                double tl_y=call.argument("tl_y");
                double tr_x=call.argument("tr_x");
                double tr_y=call.argument("tr_y");
                double bl_x=call.argument("bl_x");
                double bl_y=call.argument("bl_y");
                double br_x=call.argument("br_x");
                double br_y=call.argument("br_y");

                if(OpenCVLoader.initDebug()) {

                    System.out.println("original started");
                    Mat mat=new Mat();
                    Utils.bitmapToMat(bitmap,mat);
                    Mat src_mat=new Mat(4,1, CvType.CV_32FC2);
                    Mat dst_mat=new Mat(4,1,CvType.CV_32FC2);
                    src_mat.put(0,0,tl_x,tl_y,tr_x,tr_y,bl_x,bl_y,br_x,br_y);
                    dst_mat.put(0,0,0.0,0.0,width,0.0, 0.0,height,width,height);
                    Mat perspectiveTransform=Imgproc.getPerspectiveTransform(src_mat, dst_mat);

                    Imgproc.warpPerspective(mat, mat, perspectiveTransform, new Size(width,height));
                    Utils.matToBitmap(mat,bitmap);
                    bitmap=Bitmap.createScaledBitmap(bitmap,2480,3508,true);
                    ByteArrayOutputStream stream=new ByteArrayOutputStream();
                    bitmap.compress(Bitmap.CompressFormat.JPEG,100,stream);
                    originalArray=stream.toByteArray();

                    result.success(originalArray);
                }
            }
        });
    }
}
