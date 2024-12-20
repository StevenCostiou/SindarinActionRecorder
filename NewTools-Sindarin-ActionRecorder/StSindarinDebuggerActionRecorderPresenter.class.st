Class {
	#name : 'StSindarinDebuggerActionRecorderPresenter',
	#superclass : 'SpPresenter',
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'toolbar',
		'registry',
		'table'
	],
	#category : 'NewTools-Sindarin-ActionRecorder',
	#package : 'NewTools-Sindarin-ActionRecorder'
}

{ #category : 'debugger extension' }
StSindarinDebuggerActionRecorderPresenter >> debuggerExtensionToolName [
	^'Debugging actions recorder'
]

{ #category : 'layout' }
StSindarinDebuggerActionRecorderPresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: #toolbar expand: false;
		add: #registry;
		yourself
]

{ #category : 'initialization' }
StSindarinDebuggerActionRecorderPresenter >> initializePresenters [
	registry := self newList.
	registry items: OrderedCollection new.
	self initializeToolbar
]

{ #category : 'initialization' }
StSindarinDebuggerActionRecorderPresenter >> initializeToolbar [

	toolbar := self newToolbar
		addStyle: 'stToolbar';
		beIcons;
		fillWith: self toolbarActions
]

{ #category : 'initialization' }
StSindarinDebuggerActionRecorderPresenter >> toolbarActions [

	| group |
	group := (CmCommandGroup named: 'Toolbar') asSpecGroup.
	group register: (SindarinRunScriptCommand forSpecContext: self).
	^ group
]
