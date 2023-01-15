// NSV13

import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Table, Section, Input, NoticeBox, LabeledList } from '../components';
import { Window } from '../layouts';

export const Navbeacon = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    location,
    ai,
    locked,
    network,
    codes = [],
  } = data;


  return (
    <Window
      resizable
      width={560}
      height={600}>
      <Window.Content scrollable>
        <Section>
          {!!locked && !ai && (
            <>
              <NoticeBox>
                Swipe a card to unlock the controls.<br />
                Location: {location ? location : "(None)"} <br />
                {codes} <br />
              </NoticeBox>
              <Table>
                {codes.map(thing => {
                  <Table.Row key={thing.code}>
                    <Table.Cell>
                      {thing.code}
                    </Table.Cell>
                    <Table.Cell>
                      {thing.value}
                    </Table.Cell>
                  </Table.Row>;
                })}
              </Table>
            </>
          )}
          {!locked && (
            <Table>
              <Table.Row>
                <Table.Cell bold>
                  Location
                </Table.Cell>
                <Table.Cell bold>
                  Actions
                </Table.Cell>
              </Table.Row>
              <Table.Row>
                <Table.Cell>
                  <Input
                    fluid
                    value={location}
                    onChange={(e, value) => act('set_location', {
                      location: value,
                    })} />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    fluid
                    content="Set Location"
                    onClick={() => act('set_location', {
                      location: location,
                    })} />
                </Table.Cell>
              </Table.Row>
            </Table>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
