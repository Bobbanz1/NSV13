// NSV13

import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Table, Section, Input, Dimmer } from '../components';
import { Window } from '../layouts';

export const Navbeacon = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    open,
    location,
    ai,
    locked,
  } = data;

  if (!open && !ai) {
    return (
      <Dimmer>
        The beacons cover is closed!
      </Dimmer>
    );
  }

  if (locked || !ai) {
    return (
      <Dimmer>
        Swipe a card to unlock the controls.<br />
        Location: {location ? location : "(None)"}
      </Dimmer>
    );
  }

  return (
    <Window
      resizable
      width={560}
      height={600}>
      <Window.Content scrollable>
        <Section>
          Hi, I am a navbeacon. I am here to help you find your way home.
        </Section>
      </Window.Content>
    </Window>
  );
};
