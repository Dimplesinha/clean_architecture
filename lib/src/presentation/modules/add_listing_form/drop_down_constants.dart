import 'package:workapp/src/presentation/modules/add_listing_form/add_listing_form_constants.dart';

class DropDownConstants {
  /// Business type dropdown constants
  static const String other = 'Other';

  /// Visibility dropdown constants
  static const String worldwide = 'Worldwide';
  static const String countrywide = 'Countrywide';
  static const String local = 'Local';
  static const String nearMe = 'Near Me';

  /// Radius dropdown constants
  static const String fiftyKm = '50 KM';
  static const String hundredKm = '100 KM';

  /// Select Skills dropdown constants
  static const String cooking = 'Cooking';
  static const String librarying = 'Librarying';

  /// Select Category dropdown constants
  static const String assembly = 'Assembly';
  static const String bookKeeping = 'Book Keeping';
  static const String cleaning = 'Cleaning';
  static const String computerHelp = 'Computer Help';
  static const String digitalMultimedia = 'Digital - MultiMedia';
  static const String electrical = 'Electrical';
  static const String entertainment = 'Entertainment';
  static const String gardening = 'Gardening';
  static const String generalLabour = 'General Labour';
  static const String organisation = 'Organisation';
  static const String individual = 'Individual';
  static const String aud = 'AUD';
  static const String inr = 'INR';
  static const String aus = 'AUS';
  static const String sale = 'Sale';
  static const String rent = 'Rent';
  static const String lease = 'Lease';
  static const String forSale = 'For Sale';
  static const String saleByNegotiation = 'Sale By Negotiation';
  static const String auction = 'Auction';
  static const String tender = 'Tender';
  static const String underOffer = 'Under Offer';
  static const String sport = 'Sport';
  static const String volunteer = 'Volunteer';
  static const String perHour = 'Per Hour';
  static const String perWeek = 'Per Week';
  static const String perMonth = 'Per Month';
  static const String perDay = 'Per Day';
  static const String yes = 'Yes';
  static const String no = 'No';

  /// Auto Type Dropdown list
  static const String car = 'Car';
  static const String motorBike = 'Motorbike';
  static const String bus = 'Bus';
  static const String truck = 'Truck';

  /// Auto Year Dropdown list
  static const String brandYear = 'Brand New';

  ///  Payment Interval
  static const String perQuarter = 'Per Quarter';
  static const String perHalfQuarter = 'Per Half-Quarter';
  static const String perYear = 'Per Year';

  /// Currency Drop Down List
  static const String iNR = 'INR';
  static const String uSD = 'USD';

  /// Vehicle Condition Dropdown list
  static const String newVehicle = 'New';
  static const String used = 'Used';
  static const String dealerDemo = 'Dealer Demo';
  static const String good = 'Good';
  static const String veryGood = 'Very Good';
  static const String average = 'Average';

  /// Classified Type List
  static const String sellItem = 'Sell Item';
  static const String advertisement = 'Advertisement';
  ///Account type Constant
  static const String personalAccountType = 'Personal';
  static const String businessAccountType = 'Business';

  /// visibility dropdownList
  static const Map<int, String> visibilityDropDownListWithLocal = {
    1: worldwide,
    2: countrywide,
    3: local,
  };

  /// visibility dropdownList
  static const Map<int, String> visibilityDropDownListWithNearMe = {
    1: worldwide,
    2: countrywide,
    3: nearMe,
  };
  static const List<String> radiusDropDownList = [fiftyKm, hundredKm];

  /// Add Community dropdownList
  static const Map<int, String> skillDropDownList = {
    1: cooking,
    2: librarying,
    3: other,
  };
  static const Map<int, String> communityTypeDropDownList = {
    1: individual,
    2: organisation,
  };

  /// Map specific to advance search only
  static const Map<int, String> advanceSearchCommunityTypeDropDownList = {
    1: individual,
    2: organisation,
    3: volunteer,
  };

  static Map<int, String> visibilityDropDownList = {
    1: worldwide,
    2: countrywide,
  };
  static const Map<int, String> saleOrRentOrLeaseList = {
    1: sale,
    2: rent,
    3: lease,
  };
  static const Map<int, String> classifiedList = {
    1: sellItem,
    2: advertisement,
  };

  /// Select Skills dropdownList
  static const List<String> currency = [aud, inr, aus];
  static const List<String> eventTypeList = [sport, entertainment, volunteer];
  static const List<String> saleOrRentList = [sale, rent, lease];
  static const Map<int, String> typeOfSaleList = {
    1: forSale,
    2: saleByNegotiation,
    3: auction,
    4: tender,
    5: underOffer,
  };
  static const Map<int, String> inspectionTypeList = {
    1: AddListingFormConstants.inspectionTime,
    2: AddListingFormConstants.byAppointment
  };
  static const List<String> propertyTypeList = [
    AddListingFormConstants.apartment,
    AddListingFormConstants.land,
    AddListingFormConstants.townhouse,
    AddListingFormConstants.villa
  ];

  /// Select Category dropdownList
  static const List<String> categoryDropDownList = [
    assembly,
    bookKeeping,
    cleaning,
    computerHelp,
    digitalMultimedia,
    electrical,
    entertainment,
    gardening,
    generalLabour,
  ];

  /// Estimated Salary time period  dropdownList
  static const Map<int, String> estimatedSalaryPeriodDropDown = {
    1: perHour,
    2: perDay,
    3: perWeek,
    4: perMonth,
    5: perQuarter,
    6: perHalfQuarter,
    7: perYear,
  };

  /// Vehicle Condition dropdownList
  static const Map<int, String> vehicleConditionDropDown = {
    1: newVehicle,
    2: used,
    3: dealerDemo,
    4: good,
    5: veryGood,
    6: average,
  };

  static const List<String> paymentIntervalList = [
    perHour,
    perDay,
    perWeek,
    perMonth,
    perQuarter,
    perHalfQuarter,
    perYear
  ];

  static List<String> getAutoYearList() {
    int currentYear = DateTime.now().year;
    List<String> yearsList = [DropDownConstants.brandYear];
    // Add years from current year to the past 10 years
    for (int i = 1; i <= 25; i++) {
      yearsList.add('${currentYear - i}');
    }
    return yearsList;
  }

  static const List<String> vehicleConditionList = [newVehicle, used, dealerDemo];
  static const List<String> currencyList = [iNR, uSD];

  /// Add real estate bedsCount
  static const List<String> countsList = [
    AddListingFormConstants.zero,
    AddListingFormConstants.one,
    AddListingFormConstants.two,
    AddListingFormConstants.three,
    AddListingFormConstants.four,
    AddListingFormConstants.five,
    AddListingFormConstants.six,
    AddListingFormConstants.seven,
    AddListingFormConstants.eight,
    AddListingFormConstants.nine,
    AddListingFormConstants.ten,
  ];

  /// Add real estate unit Of Measure
  static const Map<int, String> unitOfMeasureDropDownList = {
    1: AddListingFormConstants.squareMeters,
    2: AddListingFormConstants.hectares,
    3: AddListingFormConstants.acres,
    4: AddListingFormConstants.squareYards,
    5: AddListingFormConstants.squareKilometers,
    6: AddListingFormConstants.squareMiles,
  };

  static Map<int, String> classifiedListDropDownList = {
    1: AddListingFormConstants.classifiedRdSellItem,
    2: AddListingFormConstants.classifiedRdPost,
    3: AddListingFormConstants.free,
  };

  static const Map< String,int> accountType = {
     personalAccountType:1,
    businessAccountType:2,
  };
}
