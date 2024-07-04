import 'dart:io';

class Book {
  String title;
  String author;
  String isbn;
  int copies;

  Book(this.title, this.author, this.isbn, this.copies);

  void borrowbook() {
    copies = copies - 1;
  }
  void returnbook() {
    copies += 1;
  }
  void displayBookInfo() {
    print('Title: $title, Author: $author, ISBN: $isbn, Copies: $copies');
  }
}

class Member {
  String name;
  String memberid;
  List<Book> borrowedbooks = [];
  Member(this.name, this.memberid); // constructor

  void borrowbook(Book book) {
    borrowedbooks.add(book);
    print('Successfully borrowed "${book.title}"');
  }


  void returnbook(Book book) {
    if (borrowedbooks.contains(book)){
      borrowedbooks.remove(book);
      print('$name returned "${book.title}"');
    } else {
      print('$name unsuccessful returned "${book.title}"');
    }
  }
}

class Library {
  List<Book> books = [];
  List<Member> members = [];

  String checkLatestIsbn() {
    return books.isNotEmpty ? books.last.isbn : "ISBN000";
  }
  void addbook(Book book) { ////// มาแก้ให้กรอก ISBN ไม่ซ้ำ
    var existingbook = books.firstWhere((b) => b.isbn == book.isbn, orElse: () => Book('', '','',0));
    if (existingbook.isbn == book.isbn) {
      print('Book with ISBN "${book.isbn}" is already exists.');
      print('Please try again');
      addFromInput();
    } else {
      books.add(book);
      print('Successfully added "${book.title}" book.');
    }
  }
  void addFromInput() {
    stdout.write('Enter title: ');
    var title = stdin.readLineSync()!;
    stdout.write('Enter author: ');
    var author = stdin.readLineSync()!;
    stdout.write('Enter isbn (The latest ISBN is ${checkLatestIsbn()}): ');
    var isbn = stdin.readLineSync()!;
    stdout.write('Enter copies: ');
    var copiesstr = stdin.readLineSync()!;
    var copies = int.parse(copiesstr);
    var newbook = Book(title,author,isbn,copies);
    addbook(newbook);
  }

  void removebook(String isbn) {
    var bookToRemove = books.firstWhere((book) => book.isbn == isbn, orElse: () => Book('', '', '', 0));
    if (bookToRemove.isbn == isbn) {
      books.remove(bookToRemove);
      print('Successfully deleted "${bookToRemove.title}".');
    } else {
      print('Book with ISBN "$isbn" does not exist in the library.');
    }
  }


  String checkLatestMemberId() {
    return members.isNotEmpty ? members.last.memberid : "M000";
  }
  void registerMemberFromInput() {
    stdout.write('Enter member ID (The latest member number is ${checkLatestMemberId()}.): ');
    var memberid = stdin.readLineSync()!;
    stdout.write('Enter member name: ');
    var name = stdin.readLineSync()!;
    Member newMember = Member(name,memberid);
    registermember(newMember);
  }
  void registermember(Member member) {
    var existingMember = members.firstWhere((m) => m.memberid == member.memberid, orElse: () => Member('', ''));
    if (existingMember.memberid == member.memberid && existingMember.memberid != '') {
      print('Member "${member.memberid}" already exists.');
      registerMemberFromInput();
    } else {
      members.add(member);
      print('Successfully added member "${member.name}".');
    }
  }

  void borrowbook(String memberid, String isbn) {
    Book? book = books.firstWhere((b) => b.isbn == isbn,
        orElse: () => Book('', '', '', 0));

    if (book.isbn == isbn && book.isbn !='') {
      if (book.copies > 0){
        // ตรวจสอบว่าสมาชิกมีอยู่ในรายชื่อหรือไม่
        Member? member = members.firstWhere((m) => m.memberid == memberid,
          orElse: () => Member('', ''));
        if (member.memberid != memberid || member.memberid == '') {
            print('Member not found.');
            print('Registering a new member before you borrow a book.');
            registerMemberFromInput();
        }
        book.borrowbook();
        member.borrowbook(book);
        print('Successfully borrowed the book with ISBN "$isbn".');
        } else {
          print('No book left.');
        }
    } else {
      print('Book with ISBN "$isbn" does not exist.');
    }
  }


  void returnbook(String memberid, String isbn) {
    Member? member = members.firstWhere((m) => m.memberid == memberid,
      orElse: () => Member('', ''));

    if (member.memberid == memberid && member.memberid != '') {
      Book? book = books.firstWhere((b) => b.isbn == isbn,
        orElse: () => Book('', '', '', 0),
      );
      if (book.isbn == isbn && book.isbn != '') {
          member.returnbook(book);
          book.returnbook();
        // if (member.borrowedbooks.contains(book)) {
        //   member.returnbook(book);
        // } else {
        //   print('${member.name} did not borrow "${book.title}"');
        // }
      } else {
        print('${member.name} did not borrow the book with ISBN "$isbn".');
      }
    } else {
      print('Member with ID "$memberid" does not exist.');
    }
  }

  void printAllbook() {
    if (books.isEmpty) {
      print('No books in the library.');
    } else {
      print('Books in the library:');
      for (var i in books) {
        print(
            'Title: ${i.title}, Author: ${i.author}, ISBN: ${i.isbn}, Copies: ${i.copies}');
      }
    }
  }
  
  void printAllmember(){
    if (members.isEmpty){
      print('No members in the library');
    }else {
      print('Members in the library:');
      for (var m in members){
        print('Name: ${m.name}, MemberId: ${m.memberid}');
      }
    }
  }

  void editbook(String isbn) {
    var bookToEdit = books.firstWhere((b) => b.isbn == isbn, orElse: () => Book('', '', '', 0));
    if (bookToEdit.isbn == isbn) {
      bookToEdit.displayBookInfo();
      stdout.write('Enter new title (currently: ${bookToEdit.title}): ');
      var newTitle = stdin.readLineSync()!;
      stdout.write('Enter new author (currently: ${bookToEdit.author}): ');
      var newAuthor = stdin.readLineSync()!;
      stdout.write('Enter new ISBN (currently: ${bookToEdit.isbn}): ');
      var newISBN = stdin.readLineSync()!;
      stdout.write('Enter new number of copies (currently: ${bookToEdit.copies}): ');
      var newCopiesStr = stdin.readLineSync()!;
      
      if (newTitle.isNotEmpty) {
        bookToEdit.title = newTitle;
      }
      if (newAuthor.isNotEmpty) {
        bookToEdit.author = newAuthor;
      }
      if (newISBN.isNotEmpty) {
        bookToEdit.isbn = newISBN;
      }
      if (newCopiesStr.isNotEmpty) {
        var newCopies = int.tryParse(newCopiesStr); //tryParse ใช้สำหรับแปลง string เป็นตัวเลข
        if (newCopies != null) {
          bookToEdit.copies = newCopies;
        } else {
          print('Invalid input for number of copies. Keeping current value (${bookToEdit.copies}).');
        }
      }

      print('Book details updated successfully:');
      bookToEdit.displayBookInfo();
    } else {
      print('Book with ISBN "$isbn" does not exist in the library.');
    }
  }

  void search(String searchTerm) {
    var results = books.where((b) => // b คือพารามิเตอร์ที่จะท่องไปใน list ของ books
        // ใช้ toLowerCase() เพื่อให้การเปรียบเทียบไม่แยกแยะตัวพิมพ์เล็ก/ใหญ่.
        b.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
        b.author.toLowerCase().contains(searchTerm.toLowerCase()) ||
        b.isbn.toLowerCase().contains(searchTerm.toLowerCase()));
    if (results.isEmpty) {
      print('No books found matching "$searchTerm".');
    } else {
      print('Search results:');
      results.forEach((b) => b.displayBookInfo());
    }
  }
}

void main() {
  /// สร้าง object Book หลายๆเล่ม ///
  Library library = Library();
  
  Book book1 = Book('1984', 'George Orwell', 'ISBN001', 3);
  Book book2 = Book('Brave New World', 'Aldous Huxley', 'ISBN002', 2);
  Book book3 = Book('The Great Gatsby', 'F. Scott Fitzgerald', 'ISBN003', 1);

  library.addbook(book1);
  library.addbook(book2);
  library.addbook(book3);
  library.printAllbook();
  print('-----------------------------------------------');
  
  /// สร้าง object Member ///
  Member member1 = Member('John Doe', 'M001');
  Member member2 = Member('Jane Smith', 'M002');
  Member member3 = Member('Alex Brown', 'M003');
  
  library.registermember(member1);
  library.registermember(member2);
  library.registermember(member3);
  library.printAllmember();

  /// สร้างระบบ CRUD + Menu ///
  while (true) {
    print('--------------[Library]-----------');
    print('1. Borrow Book');
    print('2. Return Book');
    print('3. Search');
    print('4. Register Member (before borrow book)');
    print('5. Manage library');
    print('Q-Exit');
    stdout.write('Please enter your choice(1-5 or Q): ');
    var choice = stdin.readLineSync();

    if (choice == 'Q' || choice == 'q') {
      break;
    }

    switch (choice) {
      case '1':
        stdout.write('Enter member ID: ');
        var memberid = stdin.readLineSync()!;
        stdout.write('Enter book ISBN: ');
        var isbn = stdin.readLineSync()!;
        library.borrowbook(memberid, isbn);
        break;

      case '2':
        stdout.write('Enter member ID: ');
        var memberid = stdin.readLineSync()!;
        stdout.write('Enter book ISBN: ');
        var isbn = stdin.readLineSync()!;
        library.returnbook(memberid, isbn);
        break;

      case '3':
        print('1. Search by name');
        print('2. Search by isbn');
        print('3. Search by author');
        stdout.write('Please enter your choice(1-3): ');
        var searchchoice = stdin.readLineSync();
        switch (searchchoice){
          case '1':
            stdout.write('Enter name of the book: ');
            var name = stdin.readLineSync()!;
            library.search(name);
            break;

          case '2':
            stdout.write('Enter isbn of the book: ');
            var isbn = stdin.readLineSync()!;
            library.search(isbn);
            break;

          case '3':
            stdout.write('Enter author name: ');
            var author = stdin.readLineSync()!;
            library.search(author);
            break;
        }
        break;

      case '4':
        stdout.write('Enter member ID: ');
        var memberid = stdin.readLineSync()!;
        stdout.write('Enter your name: ');
        var name = stdin.readLineSync()!;
        var member = Member(name,memberid);
        library.registermember(member);
        break;

      case '5':
        print('--------------[Manage Library]-------------');
        print('1. Add new book');
        print('2. Remove Book');
        print('3. Edit book');
        stdout.write('Please enter your choice(1-3): ');
        var choice = stdin.readLineSync();
        switch (choice){
          case '1':
            library.addFromInput();
            break;

          case '2':
            stdout.write('Enter isbn: ');
            var isbn = stdin.readLineSync()!;
            library.removebook(isbn);
            break;

          case '3':
            print('---------------[Edit book detail]--------------');
            stdout.write('Enter isbn of the book to edit: ');
            var isbn = stdin.readLineSync()!;
            library.editbook(isbn);
            break;
        }
        break;
    }
  }
}
