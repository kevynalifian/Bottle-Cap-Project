# Bottle-Cap-Project

Saya Kevyn Alifian Hernanda Wibowo sebagai salah satu pelamar Machine Learning Engineer di Ada Mata. Berikut merupakan penjelasan terkait alur penelitian yang telah saya lakukan untuk memenuhi Technical Test.

## Flowchart
<img width="3138" height="1742" alt="Flowchart" src="https://github.com/user-attachments/assets/31ba9925-bb00-46b3-a353-a0535c9311d3" />

### Penjelasan singkat dataset
Berdasarkan dataset yang diberikan, yang berisi 12 gambar tutup botol dan file .txt berformat YOLO berisi koordinat bounding box.

### Tahap Re-Labelling
Tahapan pertama yang saya lakukan adalah re-labelling, dataset terlebih dahulu diinput kemudian dilakukan konversi warna dari RGB ke HSV untuk memudahkan proses pendeteksian warna. Selanjutnya, Region of Interest (ROI) ditentukan dengan memanfaatkan titik koordinat bounding box yang tersedia pada file .txt, sehingga area tutup botol dapat dicrop secara presisi. Setelah gambar berada pada ruang warna HSV dan telah dipotong sesuai ROI, tutup botol kemudian diklasifikasikan ulang menjadi tiga kelas, yaitu light blue, dark blue, dan others berdasarkan nilai Hue, Saturation, dan Value yang telah ditetapkan sebelumnya.Tahapan re-labelling diakhiri dengan menghasilkan file .txt label baru yang memuat kelas objek hasil klasifikasi ulang. Berikut merupakan visualisasi proses re-labelling dalam project ini.
<img width="2207" height="1791" alt="Group 262" src="https://github.com/user-attachments/assets/edf06c83-8d0e-47a4-bee0-59c98022a6a5" />


Kemudian dibawah ini merupakan hasil proses re-labelling.

<img width="390" height="504" alt="download (3)" src="https://github.com/user-attachments/assets/b1cdd446-455f-4b30-83b3-72d63c9e3804" />

### Splitting Dataset
Tahapan selanjutnya adalah memisahkan dataset. Dataset yang telah melalui proses re-labelling dan siap digunakan kemudian dibagi dengan rasio 80:10:10, sehingga diperoleh data train sebanyak 9 file, data validation sebanyak 1 file, dan data test sebanyak 2 file.

### Building YOLO Model
Tahapan selanjutnya adalah eksplorasi model YOLO. Pemilihan YOLO didasarkan pada format anotasi dataset pada file .txt yang sudah berisi koordinat bounding box dalam format YOLO, sehingga penggunaan YOLO merupakan pendekatan yang paling relevan dan efisien tanpa perlu melakukan konversi anotasi. Sebelum itu saya perlu membuat file.yaml yang berisi path dataset dan jumlah kelas yang ingin di klasifikasi. Pada tahap eksplorasi ini, saya membandingkan kinerja tiga varian model yaitu YOLOv5n, YOLOv8n, dan YOLOv11n, yang seluruhnya dilatih menggunakan data train dan data validation.

- YOLOv5n dipilih karena model ini ringan dan cepat sehingga cocok untuk perangkat terbatas, namun akurasinya relatif lebih rendah dibandingkan generasi berikutnya.
- YOLOv8n dipilih karena merupakan generasi yang lebih baru dengan peningkatan struktur arsitektur, optimasi deteksi objek kecil, dan inferensi lebih stabil, meskipun ukuran model sedikit lebih besar dibandingkan YOLOv5n.
- YOLOv11n dipilih karena merupakan model terbaru dengan peningkatan efisiensi inference, namun dataset yang kecil berpotensi membuat model ini belum dapat menggeneralisasi secara optimal.

### Perfomance Evaluation from various YOLO Model
Setelah proses pelatihan selesai, dilakukan pengujian menggunakan data test. Hasil visualisasi prediksi ditunjukkan pada gambar dibawah ini, di mana setiap model mendeteksi tutup botol dengan tingkat akurasi yang berbeda.
<img width="1350" height="623" alt="Result testing" src="https://github.com/user-attachments/assets/06d82b92-a7de-49ad-9f95-05246f5edd4b" />

- YOLOv5n mendeteksi beberapa objek, namun label warna kurang konsisten dan confidence relatif rendah.
- YOLOv11n mampu mendeteksi objek utama tetapi melewatkan sebagian objek yang seharusnya terdeteksi.
- YOLOv8n menunjukkan performa terbaik dengan jumlah deteksi objek paling lengkap dan klasifikasi warna yang paling akurat, didukung oleh confidence score yang lebih stabil.

Berdasarkan hasil tersebut, YOLOv8n dipilih sebagai model terbaik untuk tahap selanjutnya, karena mampu memberikan keseimbangan optimal antara akurasi, stabilitas inferensi, dan kapasitas generalisasi pada dataset tutup botol yang berukuran kecil. Hal tersebut juga dibuktikan dengan loss dan metrik evaluasi YOLOv8n menggunakan data train dan data val selama proses training berlangsung yang ditunjukkan pada gambar dibawah ini.
<img width="1674" height="2158" alt="Group 266" src="https://github.com/user-attachments/assets/855be276-7d17-4678-bdfa-9f61f014dc4e" />

## Informasi Tambahan
Berdasarkan penelitian yang telah saya lakukan, terdapat ketidakseimbangan distribusi kelas pada dataset tutup botol, antara kelas light blue, dark blue, dan others. Hal ini terlihat pada grafik distribusi kelas, di mana kelas others mendominasi secara signifikan dibandingkan dua kelas lainnya. Ketidakseimbangan ini berpotensi menimbulkan bias pada model, karena model cenderung belajar lebih banyak dari kelas yang dominan sehingga dapat mengurangi sensitivitas terhadap kelas light blue dan dark blue.
<img width="841" height="547" alt="download (4)" src="https://github.com/user-attachments/assets/e42fb92e-c1a0-46c3-a18a-469f5a5fe7a6" />


Selain itu, tantangan lain yang ditemukan adalah kondisi pencahayaan pada dataset. Variasi intensitas cahaya yang cukup ekstrem mengakibatkan perbedaan warna yang tidak konsisten, sehingga proses relabeling berbasis HSV harus dilakukan dengan sangat hati-hati untuk menghindari kesalahan klasifikasi warna. Kondisi pencahayaan yang kurang stabil ini juga dapat memengaruhi kemampuan model dalam membedakan kelas saat proses inferensi.

Secara keseluruhan, class imbalance dan kualitas pencahayaan merupakan dua faktor yang paling berpengaruh terhadap performa model, karena keduanya dapat meningkatkan risiko bias serta mengurangi kemampuan generalisasi model terhadap kelas minoritas.


