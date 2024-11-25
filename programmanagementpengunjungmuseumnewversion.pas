program MuseumVisitorManagement;

uses crt;

type
    TVisitor = record
        Name: string[50];
        Age: Integer;
        VisitDate: string[10];
    end;

var
    VisitorFile: file of TVisitor;
    Visitor: TVisitor;
    Choice: Integer;
    SearchName: string;

procedure AddVisitor;
begin
    // Buka file dalam mode append atau create jika tidak ada
    {$I-}
    Assign(VisitorFile, 'visitors.dat');
    Reset(VisitorFile);
    if IOResult <> 0 then
        Rewrite(VisitorFile);
    Seek(VisitorFile, FileSize(VisitorFile));
    {$I+}
    
    // Input data pengunjung
    Write('Masukkan Nama Pengunjung: ');
    ReadLn(Visitor.Name);
    Write('Masukkan Umur Pengunjung: ');
    ReadLn(Visitor.Age);
    Write('Masukkan Tanggal Kunjungan (DD-MM-YYYY): ');
    ReadLn(Visitor.VisitDate);
    
    // Tulis data ke file
    Write(VisitorFile, Visitor);
    Close(VisitorFile);
    WriteLn('Pengunjung Berhasil Ditambahkan.');
end;

procedure DisplayVisitors;
begin
    // Cek dan buka file
    {$I-}
    Assign(VisitorFile, 'visitors.dat');
    Reset(VisitorFile);
    if IOResult <> 0 then
    begin
        WriteLn('No visitors data or error opening file.');
        Exit;
    end;
    {$I+}
    
    // Tampilkan semua pengunjung
    WriteLn('List of Visitors:');
    while not Eof(VisitorFile) do
    begin
        Read(VisitorFile, Visitor);
        WriteLn('Nama: ', Visitor.Name, 
                ', Umur: ', Visitor.Age, 
                ', Tanggal Kunjungan: ', Visitor.VisitDate);
    end;
    
    Close(VisitorFile);
end;

procedure RecursiveSearchVisitor(Index: Integer);
begin
    // Set pointer ke posisi yang sesuai
    Seek(VisitorFile, Index);
    Read(VisitorFile, Visitor);
    
    // Bandingkan nama
    if LowerCase(Visitor.Name) = LowerCase(SearchName) then
    begin
        WriteLn('Pengunjung Ditemukan:');
        WriteLn('Nama: ', Visitor.Name);
        WriteLn('Umur: ', Visitor.Age);
        WriteLn('Tanggal Kunjungan: ', Visitor.VisitDate);
    end
    else
    begin
        // Jika belum mencapai akhir file, panggil rekursif untuk mencari di index berikutnya
        if Index < FileSize(VisitorFile) - 1 then
            RecursiveSearchVisitor(Index + 1
        )
        else
            WriteLn('Pengunjung Tidak Ditemukan.');
    end;
end;

procedure SearchVisitor;
begin
    // Buka file
    {$I-}
    Assign(VisitorFile, 'visitors.dat');
    Reset(VisitorFile);
    if IOResult <> 0 then
    begin
        WriteLn('Error opening file or no data.');
        Exit;
    end;
    {$I+}

    // Input nama yang dicari
    Write('Ketik Nama Untuk Mencari: ');
    ReadLn(SearchName);

    // Panggil fungsi rekursif untuk mencari dari index 0
    RecursiveSearchVisitor(0);

    Close(VisitorFile);
end;

procedure DeleteVisitor;
var
    TempFile: file of TVisitor;
    Found: Boolean;
begin
    Found := False;
    
    // Buka file asli dan file sementara
    {$I-}
    Assign(VisitorFile, 'visitors.dat');
    Assign(TempFile, 'temp_visitors.dat');
    Reset(VisitorFile);
    Rewrite(TempFile);
    
    if IOResult <> 0 then
    begin
        WriteLn('Error opening files.');
        Exit;
    end;
    {$I+}
    
    // Input nama yang akan dihapus
    Write('Masukkan Nama Untuk Menghapus: ');
    ReadLn(SearchName);
    
    // Proses penghapusan
    while not Eof(VisitorFile) do
    begin
        Read(VisitorFile, Visitor);
        if LowerCase(Visitor.Name) <> LowerCase(SearchName) then
        begin
            Write(TempFile, Visitor);
        end
        else
        begin
            Found := True;
        end;
    end;
    
    Close(VisitorFile);
    Close(TempFile);
    
    // Hapus file lama dan rename file sementara
    Erase(VisitorFile);
    Rename(TempFile, 'visitors.dat');
    
    // Tampilkan pesan
    if Found then
        WriteLn('Pengunjung Berhasil Dihapus.')
    else
        WriteLn('Pengunjung Tidak Ditemukan.');
end;

// Program Utama
begin
    // Bersihkan layar
    ClrScr;
    
    // Loop menu utama
    repeat
        textcolor(11);
        WriteLn('--- Selamat Datang di Sistem Pengelolaan Data Pengunjung Museum ---');
        textcolor(15);
        WriteLn('1. Tambahkan Pengunjung');
        WriteLn('2. Tampilkan Pengunjung');
        WriteLn('3. Cari Pengunjung');
        WriteLn('4. Hapus Pengunjung');
        WriteLn('5. Keluar');
        Write('Pilih Opsi (1-5): ');
        ReadLn(Choice);
        
        // Pilihan menu
        case Choice of
            1: AddVisitor;
            2: DisplayVisitors;
            3: SearchVisitor;
            4: DeleteVisitor;
            5: WriteLn('Keluar Dari Program...');
            else 
                WriteLn('Pilihan Tidak Valid. Mohon Coba Lagi.');
        end;
        
        WriteLn;
        WriteLn('Tekan Enter Untuk Melanjutkan...');
        ReadLn;
        ClrScr;
    until Choice = 5;
end.