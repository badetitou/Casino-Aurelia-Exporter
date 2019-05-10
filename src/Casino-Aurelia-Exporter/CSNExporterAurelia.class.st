Class {
	#name : #CSNExporterAurelia,
	#superclass : #CSNModelExporter,
	#instVars : [
		'exportStream'
	],
	#category : #'Casino-Aurelia-Exporter'
}

{ #category : #visiting }
CSNExporterAurelia >> attributeMap [
	^ {(CSNUIClass -> 'class').
	(CSNUILabel -> 'label').
	(CSNUIWidth -> 'width').
	(CSNUIAbsoluteWidth -> 'width').
	(CSNUIRelativeWidth -> 'width').
	(CSNUIAbsoluteHeight -> 'height').
	(CSNUIRelativeHeight -> 'height').
	(CSNUIHeight -> 'height').
	(CSNUIValue -> 'value')} asDictionary
]

{ #category : #visiting }
CSNExporterAurelia >> attributesTagFor: aWidget [
	^ ((aWidget attributes groupedBy: #class) asDictionary associations
		collect: [ :mapAttributeNameValues | 
			' '
				,
					(self context bindingAttributeMap
						at: mapAttributeNameValues key
						ifAbsent: [ 'unknowAttribute' ]) , '="'
				,
					((mapAttributeNameValues value asOrderedCollection
						flatCollect: [ :attribute | (self visit: attribute) , ' ' ])
						removeLast;
						yourself) , '"' ]) joinUsing: ''
]

{ #category : #visiting }
CSNExporterAurelia >> prepareExport [
	context := CSNContextAurelia new
		root: (FileSystem disk workingDirectory / model name) asFileReference;
		bindingAttributeMap: self attributeMap; yourself
]

{ #category : #visiting }
CSNExporterAurelia >> visitAttribute: anAttribute [
	^ anAttribute attributeValue 
]

{ #category : #visiting }
CSNExporterAurelia >> visitMooseModel: aMooseModel [
self root ensureCreateDirectory.
	aMooseModel allCSNPage do: [ :aPage | self visit: aPage ]
]

{ #category : #visiting }
CSNExporterAurelia >> visitPage: aPage [
	exportStream := (self root / (aPage name , '.html')) writeStream.
	exportStream
		nextPutAll: '<template>' , String crlf;
		nextPutAll: '<require from="./' , aPage name,'.css"></require>';
		nextPutAll: '<page id=' , aPage name , '>' , String crlf.
	aPage widgets do: [ :aWidget | self visit: aWidget ].
	exportStream
		nextPutAll: '</page>' , String crlf;
		nextPutAll: '</template>' , String crlf;
		flush;
		close.
	exportStream := (self root / (aPage name , '.css')) writeStream.
	exportStream
		flush;
		close
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIBorder: aBorder [
	exportStream
		nextPutAll: '<div' , (self attributesTagFor: aBorder) , '>'; nextPutAll: String crlf.
	aBorder widgets do: [ :aWidget | self visit: aWidget ].
	exportStream nextPutAll: '</div>' , String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIButton: aButton [
	exportStream
		nextPutAll: '<button type="button">'.
		aButton attributes
		select: [ :attribute | attribute isKindOf: CSNUILabel ]
		thenDo: [ :attribute | exportStream nextPutAll: (self visit: attribute) ].
		exportStream nextPutAll: '</button>' , String crlf.
		
]

{ #category : #visiting }
CSNExporterAurelia >> visitUICanvas: aCanvas [
	exportStream
		nextPutAll: '<canvas' , (self attributesTagFor: aCanvas) , '>' ; nextPutAll: String crlf.
	aCanvas widgets do: [ :aWidget | self visit: aWidget ].
	exportStream nextPutAll: '</canvas>' , String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIContainer: aContainer [
	exportStream
		nextPutAll: '<div';
		nextPutAll: (self attributesTagFor: aContainer);
		nextPutAll: '><!-->widget non reconnu<-->';
		nextPutAll: '</widget non reconnu>';
		nextPutAll: String crlf.
	aContainer widgets do: [ :aWidget | self visit: aWidget ].
	exportStream
		nextPutAll: '</div>';
		nextPutAll: String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIHeading1: aUIHeading1 [
	exportStream nextPutAll: '<h1>'.
	aUIHeading1 attributes
		select: [ :attribute | attribute isKindOf: CSNUILabel ]
		thenDo: [ :attribute | exportStream nextPutAll: (self visit: attribute) ].
	exportStream nextPutAll: '</h1>' , String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIInputCheckbox: anInputCheckBox [
	exportStream
		nextPutAll:
			'<input type="checkbox"' , (self attributesTagFor: anInputCheckBox)
				, '/>';
		nextPutAll: String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIInputComboBox: anInputComboBox [
	exportStream
		nextPutAll:
			'<input type="combobox"' , (self attributesTagFor: anInputComboBox)
				, '/>';
		nextPutAll: String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIInputDate: anInputDate [
	exportStream
		nextPutAll:
			'<input type="date"' , (self attributesTagFor: anInputDate) , '/>';
			nextPutAll: String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIInputListBox: anInputListBox [
	exportStream
		nextPutAll:
			'<input type="listbox"' , (self attributesTagFor: anInputListBox)
				, '/>';
		nextPutAll: String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIInputRadio: anInputRadio [
	exportStream
		nextPutAll: '<input type="radio"' , (self attributesTagFor: anInputRadio) , '/>';
		nextPutAll: String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIInputText: anInputText [
	exportStream
		nextPutAll: '<input type="text"' , (self attributesTagFor: anInputText) , '/>';
		nextPutAll: String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIPanel: aPanel [
	exportStream
		nextPutAll: '<div' , (self attributesTagFor: aPanel) , '>' ; nextPutAll: String crlf.
	aPanel widgets do: [ :aWidget | self visit: aWidget ].
	exportStream nextPutAll: '</div>' , String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIParagraph: aUIParagraph [
	exportStream nextPutAll: '<p>'.
	aUIParagraph attributes
		select: [ :attribute | attribute isKindOf: CSNUILabel ]
		thenDo: [ :attribute | exportStream nextPutAll: (self visit: attribute) ].
	exportStream nextPutAll: '</p>' , String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUISelect: anInputDate [
	exportStream
		nextPutAll: '<select';
		nextPutAll: (self attributesTagFor: anInputDate);
		nextPutAll: '/>';
		nextPutAll: String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUITable: aTable [
	exportStream
		nextPutAll: '<table' , (self attributesTagFor: aTable) , '>' ;nextPutAll: String crlf.
	aTable widgets do: [ :aWidget | self visit: aWidget ].
	exportStream nextPutAll: '</table>' , String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUITableCell: aTableCell [
	exportStream
		nextPutAll: '<td' , (self attributesTagFor: aTableCell) , '>' ;nextPutAll: String crlf.
	aTableCell widgets do: [ :aWidget | self visit: aWidget ].
	exportStream nextPutAll: '</td>' , String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUITableRow: aTableRow [
	exportStream
		nextPutAll: '<tr' , (self attributesTagFor: aTableRow) , '>' ;nextPutAll: String crlf.
	aTableRow widgets do: [ :aWidget | self visit: aWidget ].
	exportStream nextPutAll: '</tr>' , String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitWidget: aWidget [
	exportStream
		nextPutAll: '<widget non reconnu';
		nextPutAll: (self attributesTagFor: aWidget);
		nextPutAll: '></widget non reconnu>';
		nextPutAll: String crlf
]
