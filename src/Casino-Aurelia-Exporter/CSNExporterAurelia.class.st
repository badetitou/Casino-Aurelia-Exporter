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
		nextPutAll: '<template>'.
		
		exportStream
		nextPutAll: '</template>';
		flush;
		close.
	exportStream := (self root / (aPage name , '.css')) writeStream.
	exportStream
		flush;
		close
]
