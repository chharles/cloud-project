# -*- coding: utf-8 -*-

# This sample demonstrates handling intents from an Alexa skill using the Alexa Skills Kit SDK for Python.
# Please visit https://alexa.design/cookbook for additional examples on implementing slots, dialog management,
# session persistence, api calls, and more.
# This sample is built using the handler classes approach in skill builder.
import logging
import ask_sdk_core.utils as ask_utils

from ask_sdk_core.skill_builder import SkillBuilder
from ask_sdk_core.dispatch_components import AbstractRequestHandler
from ask_sdk_core.dispatch_components import AbstractExceptionHandler
from ask_sdk_core.handler_input import HandlerInput

from ask_sdk_model import Response

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


class LaunchRequestHandler(AbstractRequestHandler):
    """Handler for Skill Launch."""
    def can_handle(self, handler_input):
        return ask_utils.is_request_type("LaunchRequest")(handler_input)

    def handle(self, handler_input):
        speak_output = "Welcome to Group 8's Assignment 1 project. What can I help you with?"
        response_text = "I can tell you who is on the team, What the name of the group is, and provide you options for the skill . Which would you like me to do for you?"
        return (
            handler_input.response_builder
                .speak(speak_output)
                .ask(response_text)
                .response
        )

class WhoIsOnTeamIntentHandler(AbstractRequestHandler):
    """Handler for WhoISOnTeam Intent."""
    def can_handle(self, handler_input):
        return ask_utils.is_intent_name("WhoIsOnTeamIntent")(handler_input)

    def handle(self, handler_input):
        speak_output = "Group 8's team members are Brantley Webb, Charlie Harper, Hui Cao, Owen Van Beber, and Reagan Wiginton"
        return (
            handler_input.response_builder
                .speak(speak_output)
                .response
        )

class ClassInformationIntentHandler(AbstractRequestHandler):
    """Handler for ClassInformation Intent."""
    def can_handle(self, handler_input):
        return ask_utils.is_intent_name("ClassInformationIntent")(handler_input)
    
    def handle(self, handler_input):
        speak_output = "This project was made for COMP fifty five thirty and sixty five thirty, Cloud Computing"
        return(
            handler_input.response_builder
            .speak(speak_output)
            .response
        )

class GroupNameIntentHandler(AbstractRequestHandler):
    """Handler for GroupName Intent."""
    def can_handle(self, handler_input):
        return ask_utils.is_intent_name("GroupNameIntent")(handler_input)

    def handle(self, handler_input):
        speak_output = "The name of this group is Group 8"
        return (
            handler_input.response_builder
                .speak(speak_output)
                .response
        )

class OptionsIntentHandler(AbstractRequestHandler):
    """Handler for Options Intent."""
    def can_handle(self, handler_input):
        return ask_utils.is_intent_name("OptionsIntent")(handler_input)

    def handle(self, handler_input):
        speak_output = "I can tell you who is on the team, What the name of the group is, what class the project is for, and provide options for the skill. Which would you like me to do for you?"
        return (
            handler_input.response_builder
                .speak(speak_output)
                .response
        )

class HelpIntentHandler(AbstractRequestHandler):
    """Handler for Help Intent."""
    def can_handle(self, handler_input):
        return ask_utils.is_intent_name("AMAZON.HelpIntent")(handler_input)

    def handle(self, handler_input):
        speak_output = "You can say hello to me! How can I help?"
        return (
            handler_input.response_builder
                .speak(speak_output)
                .ask(speak_output)
                .response
        )

class CancelOrStopIntentHandler(AbstractRequestHandler):
    """Single handler for Cancel and Stop Intent."""
    def can_handle(self, handler_input):
        return (ask_utils.is_intent_name("AMAZON.CancelIntent")(handler_input) or
                ask_utils.is_intent_name("AMAZON.StopIntent")(handler_input))

    def handle(self, handler_input):
        speak_output = "Goodbye!"
        return (
            handler_input.response_builder
                .speak(speak_output)
                .response
        )

class SessionEndedRequestHandler(AbstractRequestHandler):
    """Handler for Session End."""
    def can_handle(self, handler_input):
        return ask_utils.is_request_type("SessionEndedRequest")(handler_input)

    def handle(self, handler_input):
        return handler_input.response_builder.response

class IntentReflectorHandler(AbstractRequestHandler):
    """The intent reflector is used for interaction model testing and debugging.
    It will simply repeat the intent the user said. You can create custom handlers
    for your intents by defining them above, then also adding them to the request
    handler chain below.
    """
    def can_handle(self, handler_input):
        return ask_utils.is_request_type("IntentRequest")(handler_input)

    def handle(self, handler_input):
        intent_name = ask_utils.get_intent_name(handler_input)
        speak_output = "You just triggered " + intent_name + "."
        return (
            handler_input.response_builder
                .speak(speak_output)
                .response
        )

class CatchAllExceptionHandler(AbstractExceptionHandler):
    """Generic error handling to capture any syntax or routing errors. If you receive an error
    stating the request handler chain is not found, you have not implemented a handler for
    the intent being invoked or included it in the skill builder below.
    """
    def can_handle(self, handler_input, exception):
        return True

    def handle(self, handler_input, exception):
        logger.error(exception, exc_info=True)

        speak_output = "Sorry, I had trouble doing what you asked. Please try again."

        return (
            handler_input.response_builder
                .speak(speak_output)
                .ask(speak_output)
                .response
        )


sb = SkillBuilder()

sb.add_request_handler(LaunchRequestHandler())
sb.add_request_handler(WhoIsOnTeamIntentHandler())
sb.add_request_handler(GroupNameIntentHandler())
sb.add_request_handler(OptionsIntentHandler())
sb.add_request_handler(ClassInformationIntentHandler())

sb.add_request_handler(HelpIntentHandler())
sb.add_request_handler(CancelOrStopIntentHandler())
sb.add_request_handler(SessionEndedRequestHandler())
sb.add_request_handler(IntentReflectorHandler()) 

sb.add_exception_handler(CatchAllExceptionHandler())

lambda_handler = sb.lambda_handler()