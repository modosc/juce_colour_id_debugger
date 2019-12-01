/*******************************************************************************
 The block below describes the properties of this module, and is read by
 the Projucer to automatically generate project code that uses it.
 For details about the syntax and how to create or use a module, see the
 JUCE Module Format.txt file.
 BEGIN_JUCE_MODULE_DECLARATION
  ID:               juce_colour_id_debugger
  vendor:           modosc
  version:          0.1.0
  name:             JUCE ColourID Debugger
  description:      A component that allows easy editing of ColourIDs
  website:          https://github.com/modosc/juce_colour_id_debugger
  license:          MIT
  dependencies:     juce_core, juce_gui_basics, juce_graphics
 END_JUCE_MODULE_DECLARATION
*******************************************************************************/


#pragma once
#define JUCE_COLOUR_ID_DEBUGGER_H_INCLUDED

#include <juce_core/juce_core.h>
#include <juce_gui_basics/juce_gui_basics.h>
#include <juce_graphics/juce_graphics.h>

class ColourIdDebugger : public juce::DocumentWindow
{
public:
  ColourIdDebugger();
  ~ColourIdDebugger();
};