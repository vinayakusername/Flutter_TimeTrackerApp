import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker_app/app/home/job_entries/format.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

//Test cases for testing format class
void main()
{
  /*
  group() function is used to test the member function of 'fomat' class by 
  grouping them.

  group() is used to write multiple test case for particular function of a class.
  */
  group('hours',()
  {
      test('positive',()
      {
        expect(Format.hours(10), '10h');
      });

      test('zero',()
      {
        expect(Format.hours(0), '0h');
      });

      test('negative',()
      {
        expect(Format.hours(-5), '0h');
      });

      test('decimal',()
      {
        expect(Format.hours(4.5), '4.5h');
      });
  });

  group('date-GB locale',()
  {
    //setUp((){}); this method always run before each test. 
    setUp(() async
    {
      Intl.defaultLocale = 'en_GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });
     test('2019-08-12',()
     {
       expect(Format.date(DateTime(2019,08,12)),'12 Aug 2019');
     });
  });

  group('dayOfWeek-GB locale', ()
  {
    setUp(()async
    {
       Intl.defaultLocale = 'en_GB';
       await initializeDateFormatting(Intl.defaultLocale);
    });

    test('Monday',()
    {
      expect(Format.dayOfWeek(DateTime(2019,08,12)), 'Mon');
    });
  });


// Below dayOfWeek and DateTime is according to Italian location
  group('dayOfWeek-IT locale', ()
  {
    setUp(()async
    {
       Intl.defaultLocale = 'it_IT';
       await initializeDateFormatting(Intl.defaultLocale);
    });

    test('Lunedi',()
    {
      expect(Format.dayOfWeek(DateTime(2019,08,12)), 'lun');
    });
  });

  group('currency - US locale',()
  {
    setUp(()
    {
       Intl.defaultLocale = 'en_US';
    });

    test('positive',()
    {
      expect(Format.currency(10),'\$10');
    });

    
    test('zero',()
    {
      expect(Format.currency(0),'');
    });

    
    test('negative',()
    {
      expect(Format.currency(-5),'-\$5');
    });
  });

}