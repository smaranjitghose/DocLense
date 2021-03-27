package com.example.documentscanner2;

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
    byte[] byteArray;
    byte[] grayArray;
    byte[] originalArray;
    byte[] whiteBoardArray;
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),"opencv").setMethodCallHandler((call, result) -> {

            if(call.method.equals("convertToGray")){
                System.out.println("convertToGray");
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
                System.out.println(tl_x);
                if(OpenCVLoader.initDebug()) {
                    System.out.println("Opencv Working");
                    Mat mat=new Mat();
                    Utils.bitmapToMat(bitmap,mat);

                    Imgproc.cvtColor(mat,mat,Imgproc.COLOR_BGR2GRAY);
                    Imgproc.GaussianBlur(mat,mat,new Size(5,5),0);
                    Mat src_mat=new Mat(4,1, CvType.CV_32FC2);
                    Mat dst_mat=new Mat(4,1,CvType.CV_32FC2);
                    src_mat.put(0,0,tl_x,tl_y,tr_x,tr_y,bl_x,bl_y,br_x,br_y);
                    dst_mat.put(0,0,0.0,0.0,width,0.0, 0.0,height,width,height);
                    Mat perspectiveTransform=Imgproc.getPerspectiveTransform(src_mat, dst_mat);

                    Imgproc.warpPerspective(mat, mat, perspectiveTransform, new Size(width,height));

                    Imgproc.adaptiveThreshold(mat,mat,255,Imgproc.ADAPTIVE_THRESH_MEAN_C,Imgproc.THRESH_BINARY,401,14);
                    Mat blurred=new Mat();
                    Imgproc.GaussianBlur(mat,blurred,new Size(5,5),0);
                    Mat result1=new Mat();
                    Core.addWeighted(blurred,0.5,mat,0.5,1,result1);

                    Utils.matToBitmap(result1,bitmap);
                    bitmap=Bitmap.createScaledBitmap(bitmap,2480,3508,true);
                    ByteArrayOutputStream stream=new ByteArrayOutputStream();
                    bitmap.compress(Bitmap.CompressFormat.JPEG,100,stream);
                    byte[] byteArray=stream.toByteArray();
                    result.success(byteArray);

                }
            }
            if(call.method.equals("original")){
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
                OriginalThread originalThread=new OriginalThread( bitmap,height,width,tl_x,tl_y,tr_x,tr_y,bl_x,bl_y,br_x,br_y);
                originalThread.start();
                result.success("");
            }
            if(call.method.equals("gray")){
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
                GrayThread grayThread=new GrayThread(
                        bitmap,height,width,tl_x,tl_y,tr_x,tr_y,bl_x,bl_y,br_x,br_y);
                grayThread.start();
                result.success("");
            }
            if(call.method.equals("whiteboard")){
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
                WhiteBoardThread whiteBoardThread=new WhiteBoardThread( bitmap,height,width,tl_x,tl_y,tr_x,tr_y,bl_x,bl_y,br_x,br_y);
                whiteBoardThread.start();
            }
            if(call.method.equals("rotate")){
                byte[] byteArray=call.argument("bytes");
                RotateThread rotateThread=new RotateThread(byteArray);
                rotateThread.start();
                result.success(byteArray);
            }
            if(call.method.equals("rotateCompleted")){
                result.success(byteArray);
            }
            if(call.method.equals("grayCompleted")){
                result.success(grayArray);
            }
            if(call.method.equals("originalCompleted")) {
                result.success(originalArray);
            }
            if(call.method.equals("whiteboardCompleted")){
                result.success(whiteBoardArray);
            }
        });
    }
    class RotateThread extends  Thread{

        RotateThread(byte[] bytes){
            byteArray=bytes;
        }
        @Override
        public void run() {
            System.out.println("started");
            Matrix matrix=new Matrix();
            matrix.postRotate(90);
            Bitmap bitmap = BitmapFactory.decodeByteArray(byteArray, 0, byteArray.length);
            Bitmap rotatedBitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
            ByteArrayOutputStream stream=new ByteArrayOutputStream();
            rotatedBitmap.compress(Bitmap.CompressFormat.JPEG,100,stream);
            byteArray=stream.toByteArray();

        }
    }
    class GrayThread extends Thread{
        Bitmap bitmap;
        int height,width;
        double tl_x,tl_y,tr_x,tr_y,bl_x,bl_y,br_x,br_y;
        GrayThread(Bitmap bitmap,int height, int width,double tl_x, double tl_y,double tr_x,double tr_y,double bl_x,double bl_y,double br_x,double br_y){
            this.bitmap=bitmap;
            this.height=height;
            this.width=width;
            this.tl_x=tl_x;
            this.tl_y=tl_y;
            this.tr_x=tr_x;
            this.tr_y=tr_y;
            this.bl_x=bl_x;
            this.bl_y=bl_y;
            this.br_x=br_x;
            this.br_y=br_y;
        }
        @Override
        public void run() {
            System.out.println("GRay started");
            Mat mat=new Mat();
            Utils.bitmapToMat(bitmap,mat);
            Mat src_mat=new Mat(4,1, CvType.CV_32FC2);
            Mat dst_mat=new Mat(4,1,CvType.CV_32FC2);
            src_mat.put(0,0,tl_x,tl_y,tr_x,tr_y,bl_x,bl_y,br_x,br_y);
            dst_mat.put(0,0,0.0,0.0,width,0.0, 0.0,height,width,height);
            Mat perspectiveTransform=Imgproc.getPerspectiveTransform(src_mat, dst_mat);

            Imgproc.warpPerspective(mat, mat, perspectiveTransform, new Size(width,height));
            Imgproc.cvtColor(mat,mat,Imgproc.COLOR_BGR2GRAY);
            Utils.matToBitmap(mat,bitmap);
            bitmap=Bitmap.createScaledBitmap(bitmap,2480,3508,true);
            ByteArrayOutputStream stream=new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG,100,stream);
            byte[] byteArray=stream.toByteArray();
            grayArray=byteArray;
        }
    }
    class OriginalThread extends Thread{
        Bitmap bitmap;
        int height,width;
        double tl_x,tl_y,tr_x,tr_y,bl_x,bl_y,br_x,br_y;
        OriginalThread(Bitmap bitmap,int height, int width,double tl_x, double tl_y,double tr_x,double tr_y,double bl_x,double bl_y,double br_x,double br_y){
            this.bitmap=bitmap;
            this.height=height;
            this.width=width;
            this.tl_x=tl_x;
            this.tl_y=tl_y;
            this.tr_x=tr_x;
            this.tr_y=tr_y;
            this.bl_x=bl_x;
            this.bl_y=bl_y;
            this.br_x=br_x;
            this.br_y=br_y;
        }
        @Override
        public void run() {
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
            byte[] byteArray=stream.toByteArray();
            originalArray=byteArray;
        }
    }
    class WhiteBoardThread extends Thread{
        Bitmap bitmap;
        int height,width;
        double tl_x,tl_y,tr_x,tr_y,bl_x,bl_y,br_x,br_y;
        WhiteBoardThread(Bitmap bitmap,int height, int width,double tl_x, double tl_y,double tr_x,double tr_y,double bl_x,double bl_y,double br_x,double br_y){
            this.bitmap=bitmap;
            this.height=height;
            this.width=width;
            this.tl_x=tl_x;
            this.tl_y=tl_y;
            this.tr_x=tr_x;
            this.tr_y=tr_y;
            this.bl_x=bl_x;
            this.bl_y=bl_y;
            this.br_x=br_x;
            this.br_y=br_y;
        }
        @Override
        public void run() {
            System.out.println("whiteboard started");
            Mat mat=new Mat();
            Utils.bitmapToMat(bitmap,mat);

            Imgproc.cvtColor(mat,mat,Imgproc.COLOR_BGR2GRAY);
            Imgproc.GaussianBlur(mat,mat,new Size(5,5),0);
            Mat src_mat=new Mat(4,1, CvType.CV_32FC2);
            Mat dst_mat=new Mat(4,1,CvType.CV_32FC2);
            src_mat.put(0,0,tl_x,tl_y,tr_x,tr_y,bl_x,bl_y,br_x,br_y);
            dst_mat.put(0,0,0.0,0.0,width,0.0, 0.0,height,width,height);
            Mat perspectiveTransform=Imgproc.getPerspectiveTransform(src_mat, dst_mat);

            Imgproc.warpPerspective(mat, mat, perspectiveTransform, new Size(width,height));

            Imgproc.adaptiveThreshold(mat,mat,255,Imgproc.ADAPTIVE_THRESH_MEAN_C,Imgproc.THRESH_BINARY,401,14);
            Mat blurred=new Mat();
            Imgproc.GaussianBlur(mat,blurred,new Size(5,5),0);
            Mat result1=new Mat();
            Core.addWeighted(blurred,0.5,mat,0.5,1,result1);

            Utils.matToBitmap(result1,bitmap);
            bitmap=Bitmap.createScaledBitmap(bitmap,2480,3508,true);
            ByteArrayOutputStream stream=new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG,100,stream);
            byte[] byteArray=stream.toByteArray();
            whiteBoardArray=byteArray;
        }
    }
}
