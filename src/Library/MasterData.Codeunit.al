codeunit 83850 "Master Data TPTE"
{
    var
        LibraryRandom: Codeunit "Library - Random";

    procedure GetGLNRandom() GLN: Code[13]
    var
        I: Integer;
        GLNList: List of [Code[13]];
    begin
        BuildGLNList(GLNList);
        I := LibraryRandom.RandIntInRange(1, GLNList.Count());
        GLNList.Get(I, GLN);
    end;

    procedure GetGTIN13Random() GTIN: Code[13]
    var
        I: Integer;
        GTINList: List of [Code[13]];
    begin
        BuildGTIN13List(GTINList);
        I := LibraryRandom.RandIntInRange(1, GTINList.Count());
        GTINList.Get(I, GTIN);
    end;

    procedure GetGTIN14Random() GTIN: Code[14]
    var
        I: Integer;
        GTINList: List of [Code[14]];
    begin
        BuildGTIN14List(GTINList);
        I := LibraryRandom.RandIntInRange(1, GTINList.Count());
        GTINList.Get(I, GTIN);
    end;

    procedure FindAddressCompleteRandom(var Address: Text[100]; var HouseNo: Text[20]; var HouseNoAdd: Text[10]; var PostCode: Code[20]; var City: Text[30])
    begin
        Address := FindAddressRandom();
        HouseNo := Format(LibraryRandom.RandIntInRange(1, 100));
        HouseNoAdd := CopyStr(FindHouseNoAdditionalRandom(), 1, MaxStrLen(HouseNoAdd));
        PostCode := CopyStr(FindPostCodeRandom(), 1, MaxStrLen(PostCode));
        City := CopyStr(FindCityRandom(), 1, MaxStrLen(City));
    end;

    procedure FindAddressRandom() Address: Text[50]
    var
        I: Integer;
        AddressList: List of [Text[50]];
    begin
        BuildAddressList(AddressList);
        I := LibraryRandom.RandIntInRange(1, AddressList.Count());
        AddressList.Get(I, Address);
    end;

    procedure FindHouseNoAdditionalRandom() HouseNo: Text[50]
    var
        I: Integer;
        HousNoAdditionList: List of [Text[50]];
    begin
        BuildHousNoAdditionList(HousNoAdditionList);
        I := LibraryRandom.RandIntInRange(1, HousNoAdditionList.Count());
        HousNoAdditionList.Get(I, HouseNo);
    end;

    procedure FindPostCodeRandom() PostCode: Text[50]
    var
        I: Integer;
        PostCodeList: List of [Text[50]];
    begin
        BuildPostCodeList(PostCodeList);
        I := LibraryRandom.RandIntInRange(1, PostCodeList.Count());
        PostCodeList.Get(I, PostCode);
    end;

    procedure FindCityRandom() City: Text[50]
    var
        I: Integer;
        CityList: List of [Text[50]];
    begin
        BuildCityList(CityList);
        I := LibraryRandom.RandIntInRange(1, CityList.Count());
        CityList.Get(I, City);
    end;

    procedure BuildHousNoAdditionList(var HousNoAdditionList: List of [Text[50]])
    begin
        HousNoAdditionList.Add('2h');
        HousNoAdditionList.Add('a');
        HousNoAdditionList.Add('b');
        HousNoAdditionList.Add('c');
        HousNoAdditionList.Add('d');
        HousNoAdditionList.Add('e');
        HousNoAdditionList.Add('f');
    end;

    procedure BuildAddressList(var AddressList: List of [Text[50]])
    begin
        AddressList.Add('`s Gravenhekje');
        AddressList.Add('`t Hol');
        AddressList.Add('1e Keucheniusstraat');
        AddressList.Add('2e Bilderdijkstraat');
        AddressList.Add('Amstelkerkstraat');
        AddressList.Add('Baarjespolder');
        AddressList.Add('Cellezusterskerk');
        AddressList.Add('Den Amstel');
        AddressList.Add('Eerste Bickersstraat');
        AddressList.Add('Franselaan');
        AddressList.Add('Gedempte Begijnensloot');
        AddressList.Add('Gedempte Nieuwesloot');
        AddressList.Add('Hartsteeg');
        AddressList.Add('Houtmanstraat');
        AddressList.Add('IJgrachtje');
        AddressList.Add('Jacob Moenenpad');
        AddressList.Add('Kaatsbaanpad');
        AddressList.Add('Laatste Hoogstraat');
        AddressList.Add('Maagdensteeg');
        AddressList.Add('Narcisstraat');
        AddressList.Add('Nieuwe gegraven Houtgracht');
        AddressList.Add('Otterwalersteegje');
        AddressList.Add('Pijpenmark');
        AddressList.Add('Quinten Massijsstraat');
        AddressList.Add('Rapensteeg');
        AddressList.Add('Sandvikweg');
        AddressList.Add('Teertuinen');
        AddressList.Add('Uiterse Steigersteeg');
        AddressList.Add('Valeriusstraat');
        AddressList.Add('Weesperplein');
        AddressList.Add('Zaksloot');
    end;

    procedure BuildCityList(var CityList: List of [Text[50]])
    begin
        CityList.Add('Alkmaar');
        CityList.Add('Hoorn');
        CityList.Add('Rotterdam');
        CityList.Add('Schagen');
        CityList.Add('Den Helder');
        CityList.Add('Venray');
        CityList.Add('Beek');
    end;

    procedure BuildPostCodeList(var PostCodeList: List of [Text[50]])
    begin
        PostCodeList.Add('1111 AA');
        PostCodeList.Add('1817 EK');
        PostCodeList.Add('1782 KH');
        PostCodeList.Add('2222 BB');
        PostCodeList.Add('2741 NX');
        PostCodeList.Add('3035 LE');
    end;

    procedure BuildGTIN14List(var GTINList: List of [Code[14]])
    begin
        GTINList.Add('63227010289525');
        GTINList.Add('99870219739756');
        GTINList.Add('57455578308603');
        GTINList.Add('37619128867002');
        GTINList.Add('26870848418330');
        GTINList.Add('56540184230620');
        GTINList.Add('60977663586740');
        GTINList.Add('88140393357485');
        GTINList.Add('98809962034659');
        GTINList.Add('49164493518189');
        GTINList.Add('19140342627683');
        GTINList.Add('45531812021011');
        GTINList.Add('31477014931574');
        GTINList.Add('80978242672483');
        GTINList.Add('65796949245486');
        GTINList.Add('14530123978649');
        GTINList.Add('12885969172938');
        GTINList.Add('59746871197239');
        GTINList.Add('50523212890429');
        GTINList.Add('47262231230040');
    end;

    procedure BuildGLNList(var GLNList: List of [Code[13]])
    begin
        GLNList.Add('9646513790178');
        GLNList.Add('6677205539617');
        GLNList.Add('2459073385169');
        GLNList.Add('1054558697266');
        GLNList.Add('1043332233141');
        GLNList.Add('9681519161850');
        GLNList.Add('1211604137781');
        GLNList.Add('7577063610987');
        GLNList.Add('1825482484549');
        GLNList.Add('4886989339005');
    end;

    procedure BuildGTIN13List(var GTINList: List of [Code[13]])
    begin
        GTINList.Add('2165691681148');
        GTINList.Add('0342163326475');
        GTINList.Add('0612268940945');
        GTINList.Add('2711322104151');
        GTINList.Add('8127684304742');
        GTINList.Add('7351344550946');
        GTINList.Add('2353147835713');
        GTINList.Add('4119685003810');
        GTINList.Add('5387611547496');
        GTINList.Add('5486544980421');
        GTINList.Add('7232375498325');
        GTINList.Add('9216262062002');
        GTINList.Add('2586989364053');
        GTINList.Add('3240256717315');
        GTINList.Add('3706185873350');
        GTINList.Add('9921031981650');
        GTINList.Add('3463003364956');
        GTINList.Add('1723518817371');
        GTINList.Add('0015033849861');
        GTINList.Add('5698871553494');
    end;
}