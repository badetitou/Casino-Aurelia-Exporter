Class {
	#name : #CSNExporterAurelia,
	#superclass : #CSNModelExporter,
	#instVars : [
		'exportStream'
	],
	#category : #'Casino-Aurelia-Exporter'
}

{ #category : #visiting }
CSNExporterAurelia >> prepareExport [ 	context := CSNContext new root: (FileSystem disk workingDirectory / model name) asFileReference; yourself.
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
CSNExporterAurelia >> visitWidget: aWidget [
	exportStream nextPutAll: '<widget non reconnu></widget non reconnu>',String crlf
]
