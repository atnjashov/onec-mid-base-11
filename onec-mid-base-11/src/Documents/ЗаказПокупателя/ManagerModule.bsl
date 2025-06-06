
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет команды СозданияНаОсновании
//
// Параметры:
// КомандыСозданияНаОсновании - Структура
// Параметры - Структура
// 
// Возвращаемое значение: 
//  - Неопределено
Функция ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
    Документы.РеализацияТоваровУслуг.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
    Документы.ОплатаОтПокупателя.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Возврат Неопределено
	
КонецФункции

//Инициализирует
//
// Параметры:
// НастройкиОбъекта - Структура
Процедура ПриОпределенииНастроекПечати(НастройкиОбъекта) Экспорт	
	НастройкиОбъекта.ПриДобавленииКомандПечати = Истина;
КонецПроцедуры

// Добавляет команды печати
// 
// Параметры:
// КомандыПечати - Структура
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Заказ покупателя
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Заказ";
	КомандаПечати.Представление = НСтр("ru = 'Заказ покупателя'");
	КомандаПечати.Порядок = 5;
	
	// Счет на оплату
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Счет";
	КомандаПечати.Представление = НСтр("ru = 'Счет на оплату'");
	КомандаПечати.Порядок = 10;
	
	// Счет на оплату
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ГарантийноеПисьмо";
	КомандаПечати.Представление = НСтр("ru = 'Гарантийное письмо'");
	КомандаПечати.Порядок = 15;
	
	// Комплект документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Счет,Заказ,ГарантийноеПисьмо";
	КомандаПечати.Представление = НСтр("ru = 'Комплект документов'");
	КомандаПечати.Порядок = 75;
	
КонецПроцедуры

//Формирует печатную форму
// 
// Параметры:
// МассивОбъектов - Массив из Структура
// ПараметрыПечати - Структура
// КоллекцияПечатныхФорм - Массив из Форма
// ОбъектыПечати - Структура
// ПараметрыВывода - Булево
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "Заказ");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьЗаказа(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Заказ покупателя'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.ЗаказПокупателя.ПФ_MXL_СчетЗаказ";
	КонецЕсли;
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "Счет");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьСчета(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Счет на оплату'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.ЗаказПокупателя.ПФ_MXL_СчетЗаказ";
	КонецЕсли;
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ГарантийноеПисьмо");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьГарантийногоПисьма(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Гарантийное письмо'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.ЗаказПокупателя.ПФ_MXL_ГарантийноеПисьмо";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПечатьСчета(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Счет";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗаказПокупателя.ПФ_MXL_СчетЗаказ");
	
	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВывестиЗаголовокСчета(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		ВывестиРеквизитыСторон(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		ВывестиТоварыУслуги(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		ВывестиПодвалСчета(ДанныеДокументов, ТабличныйДокумент, Макет);
		
        // В табличном документе необходимо задать имя области, в которую был 
        // выведен объект. Нужно для возможности печати комплектов документов.
        УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
            НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);		
		
	КонецЦикла;	
		
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьЗаказа(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Заказ";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗаказПокупателя.ПФ_MXL_СчетЗаказ");
	
	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВывестиЗаголовокЗаказа(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		ВывестиРеквизитыСторон(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		ВывестиТоварыУслуги(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		ВывестиПодвалЗаказа(ДанныеДокументов, ТабличныйДокумент, Макет);
		
        // В табличном документе необходимо задать имя области, в которую был 
        // выведен объект. Нужно для возможности печати комплектов документов.
        УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
            НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);		
		
	КонецЦикла;	
		
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьГарантийногоПисьма(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ГарантийноеПисьмо";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗаказПокупателя.ПФ_MXL_ГарантийноеПисьмо");
	
	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВывестиГарантийноеПисьмо(ДанныеДокументов, ТабличныйДокумент, Макет);
		
        // В табличном документе необходимо задать имя области, в которую был 
        // выведен объект. Нужно для возможности печати комплектов документов.
        УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
            НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);		
		
	КонецЦикла;	
		
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьДанныеДокументов(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаказПокупателя.Ссылка КАК Ссылка,
	               |	ЗаказПокупателя.Номер КАК Номер,
	               |	ЗаказПокупателя.Дата КАК Дата,
	               |	ЗаказПокупателя.Организация КАК Организация,
	               |	ЗаказПокупателя.Контрагент КАК Контрагент,
	               |	ЗаказПокупателя.Договор КАК Договор,
	               |	ЗаказПокупателя.СуммаДокумента КАК СуммаДокумента,
	               |	ЗаказПокупателя.Ответственный КАК Ответственный,
	               |	ЗаказПокупателя.Товары.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура КАК Номенклатура,
	               |		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |		Количество КАК Количество,
	               |		Цена КАК Цена,
	               |		Сумма КАК Сумма
	               |	) КАК Товары,
	               |	ЗаказПокупателя.Услуги.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура КАК Номенклатура,
	               |		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |		Количество КАК Количество,
	               |		Цена КАК Цена,
	               |		Сумма КАК Сумма
	               |	) КАК Услуги
	               |ИЗ
	               |	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	               |ГДЕ
	               |	ЗаказПокупателя.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Процедура ВывестиЗаголовокСчета(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьЗаголовокСчета = Макет.ПолучитьОбласть("ЗаголовокСчета");
	ОбластьЗаголовокДокумента = Макет.ПолучитьОбласть("Заголовок");
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("ПредставлениеПолучателя", ДанныеДокументов.Контрагент);
	
	ШаблонЗаголовка = "Счет на оплату %1 от %2";
	ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка,
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер),
		Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
	ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
	
	ОбластьЗаголовокСчета.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьЗаголовокСчета);
	
	ОбластьЗаголовокДокумента.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьЗаголовокДокумента);
	
КонецПроцедуры

Процедура ВывестиЗаголовокЗаказа(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьЗаголовокДокумента = Макет.ПолучитьОбласть("Заголовок");
	
	ДанныеПечати = Новый Структура;
	
	ШаблонЗаголовка = "Заказ покупателя %1 от %2";
	ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка,
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер),
		Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
	ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
	
	ОбластьЗаголовокДокумента.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьЗаголовокДокумента);
	
КонецПроцедуры

Процедура ВывестиРеквизитыСторон(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьПоставщик = Макет.ПолучитьОбласть("Поставщик");
	ОбластьПокупатель = Макет.ПолучитьОбласть("Покупатель");
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("ПредставлениеПоставщика", ДанныеДокументов.Организация);
	ДанныеПечати.Вставить("ПредставлениеПокупателя", ДанныеДокументов.Контрагент);
	ДанныеПечати.Вставить("Основание", ДанныеДокументов.Договор);
	
	ОбластьПоставщик.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьПоставщик);
	
	ОбластьПокупатель.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьПокупатель);
	
КонецПроцедуры

Процедура ВывестиТоварыУслуги(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьИтого = Макет.ПолучитьОбласть("Итого");
	
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	ВыборкаТовары = ДанныеДокументов.Товары.Выбрать();
	Пока ВыборкаТовары.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(ВыборкаТовары);
		ТабличныйДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	ВыборкаУслуги = ДанныеДокументов.Услуги.Выбрать();
	Пока ВыборкаУслуги.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(ВыборкаУслуги);
		ТабличныйДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("Всего", ДанныеДокументов.СуммаДокумента);
	
	ОбластьИтого.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьИтого);
	
КонецПроцедуры

Процедура ВывестиПодвалСчета(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьПодвалСчета = Макет.ПолучитьОбласть("ПодвалСчета");

	ТабличныйДокумент.Вывести(ОбластьПодвалСчета);
	
КонецПроцедуры

Процедура ВывестиПодвалЗаказа(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьПодвалЗаказа = Макет.ПолучитьОбласть("ПодвалЗаказа");

	ТабличныйДокумент.Вывести(ОбластьПодвалЗаказа);
	
КонецПроцедуры

Процедура ВывестиГарантийноеПисьмо(ДанныеДокументов, ТабличныйДокумент, Макет)
	
	ОбластьТекстПисьма = Макет.ПолучитьОбласть("ТекстПисьма");
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("Организация", ДанныеДокументов.Организация);
	ДанныеПечати.Вставить("Контрагент", ДанныеДокументов.Контрагент);
	
	ОбластьТекстПисьма.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьТекстПисьма);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли