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
    WriteLn('Enter Visitor Name: ');
    ReadLn(Visitor.Name);
    WriteLn('Enter Visitor Age: ');
    ReadLn(Visitor.Age);
    WriteLn('Enter Visit Date (DD-MM-YYYY): ');
    ReadLn(Visitor.VisitDate);
    
    // Tulis data ke file
    Write(VisitorFile, Visitor);
    Close(VisitorFile);
    WriteLn('Visitor added successfully.');
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
        WriteLn('Name: ', Visitor.Name, 
                ', Age: ', Visitor.Age, 
                ', Visit Date: ', Visitor.VisitDate);
    end;
    
    Close(VisitorFile);
end;

procedure SearchVisitor;
var
    Found: Boolean;
begin
    Found := False;
    
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
    Write('Enter name to search: ');
    ReadLn(SearchName);
    
    // Cari pengunjung
    while not Eof(VisitorFile) do
    begin
        Read(VisitorFile, Visitor);
        if Lowercase(Visitor.Name) = Lowercase(SearchName) then
        begin
            WriteLn('Visitor found:');
            WriteLn('Name: ', Visitor.Name);
            WriteLn('Age: ', Visitor.Age);
            WriteLn('Visit Date: ', Visitor.VisitDate);
            Found := True;
            Break;
        end;
    end;
    
    Close(VisitorFile);
    
    // Tampilkan pesan jika tidak ditemukan
    if not Found then
        WriteLn('Visitor not found.');
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
    Write('Enter name to delete: ');
    ReadLn(SearchName);
    
    // Proses penghapusan
    while not Eof(VisitorFile) do
    begin
        Read(VisitorFile, Visitor);
        if Lowercase(Visitor.Name) <> Lowercase(SearchName) then
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
        WriteLn('Visitor deleted successfully.')
    else
        WriteLn('Visitor not found.');
end;

// Program Utama
begin
    // Bersihkan layar
    ClrScr;
    
    // Loop menu utama
    repeat
        WriteLn('--- Museum Visitor Management System ---');
        WriteLn('1. Add Visitor');
        WriteLn('2. Display Visitors');
        WriteLn('3. Search Visitor');
        WriteLn('4. Delete Visitor');
        WriteLn('5. Exit');
        Write('Choose an option (1-5): ');
        ReadLn(Choice);
        
        // Pilihan menu
        case Choice of
            1: AddVisitor;
            2: DisplayVisitors;
            3: SearchVisitor;
            4: DeleteVisitor;
            5: WriteLn('Exiting program...');
            else 
                WriteLn('Invalid choice. Please try again.');
        end;
        
        WriteLn;
        WriteLn('Press Enter to continue...');
        ReadLn;
        ClrScr;
    until Choice = 5;
end.