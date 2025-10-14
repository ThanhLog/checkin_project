import React, { useRef, useState, useEffect } from "react";

interface Props {
  onCapture: (file: File) => void;
}

const CameraView: React.FC<Props> = ({ onCapture }) => {
  const videoRef = useRef<HTMLVideoElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);
  const [stream, setStream] = useState<MediaStream | null>(null);

  // 🎥 Mở camera khi component mount
  useEffect(() => {
    startCamera();
    return () => stopCamera();
  }, []);

  const startCamera = async () => {
    try {
      const s = await navigator.mediaDevices.getUserMedia({ video: true });
      setStream(s);
      if (videoRef.current) videoRef.current.srcObject = s;
    } catch (err) {
      console.error("❌ Không thể mở camera:", err);
      alert("Không thể truy cập camera. Vui lòng kiểm tra quyền truy cập.");
    }
  };

  const stopCamera = () => {
    if (stream) {
      stream.getTracks().forEach((track) => track.stop());
      setStream(null);
    }
  };

  // 📸 Hàm chụp ảnh
  const handleCapture = () => {
    const canvas = canvasRef.current;
    const video = videoRef.current;
    if (!canvas || !video) return;

    const ctx = canvas.getContext("2d");
    if (ctx) {
      ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
      canvas.toBlob((blob) => {
        if (blob) {
          const file = new File([blob], "face.png", { type: "image/png" });
          setPreviewUrl(URL.createObjectURL(blob));
          onCapture(file);
          stopCamera(); // 🔴 Dừng camera hoàn toàn sau khi chụp
        }
      });
    }
  };

  // 🔁 Chụp lại
  const handleRetake = async () => {
    setPreviewUrl(null);
    await startCamera(); // ✅ Mở lại camera mới
  };

  return (
    <div className="flex flex-col items-center">
      {!previewUrl ? (
        <>
          {/* Live Camera */}
          <video
            ref={videoRef}
            autoPlay
            playsInline
            className="w-full rounded-lg shadow-md"
          />
          <canvas ref={canvasRef} width={320} height={240} hidden />
          <button
            onClick={handleCapture}
            className="mt-3 bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-xl"
          >
            📸 Chụp khuôn mặt
          </button>
        </>
      ) : (
        <>
          {/* Ảnh Preview */}
          <img
            src={previewUrl}
            alt="Preview"
            className="w-full rounded-lg shadow-md object-cover"
          />
          <button
            onClick={handleRetake}
            className="mt-3 bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded-xl"
          >
            🔁 Chụp lại
          </button>
        </>
      )}
    </div>
  );
};

export default CameraView;