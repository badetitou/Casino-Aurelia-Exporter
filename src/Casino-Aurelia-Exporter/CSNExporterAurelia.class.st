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
	^ {(CSNUIClass -> 'class')} asDictionary
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
						yourself) , '"' ]) flatten
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
		nextPutAll: '<template>',String crlf;
		nextPutAll: '<page id=' , aPage name , '>',String crlf.
	aPage widgets do: [ :aWidget | self visit: aWidget ].
	exportStream
		nextPutAll: '</page>',String crlf;
		nextPutAll: '</template>',String crlf;
		flush;
		close.
	exportStream := (self root / (aPage name , '.css')) writeStream.
	exportStream
		flush;
		close
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIContainer: aContainer [
	exportStream nextPutAll: '<div><!-->widget non reconnu<-->',String crlf.
	aContainer widgets do: [ :aWidget | self visit: aWidget ].
	exportStream nextPutAll: '</div>',String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitUIPanel: aPanel [
	exportStream
		nextPutAll: '<div ', (self attributesTagFor: aPanel) , '>' , String crlf.
	aPanel widgets do: [ :aWidget | self visit: aWidget ].
	exportStream nextPutAll: '</div>' , String crlf
]

{ #category : #visiting }
CSNExporterAurelia >> visitWidget: aWidget [
	exportStream nextPutAll: '<widget non reconnu></widget non reconnu>',String crlf
]
