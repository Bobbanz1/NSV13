// NSV13

import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Section, ProgressBar, Slider, Table } from '../components';
import { Window } from '../layouts';
import { formatPower } from '../format';
import { toFixed } from 'common/math';

// Common power multiplier
const POWER_MUL = 1e6;

export const RelativityModifier = (props, context) => {
  const { act, data } = useBackend(context);
  const availablePower = data.available_power;
  return (
    <Window
      resizable
      theme="ntos"
      width={560}
      height={600}>
      <Window.Content scrollable>
        <Section title="Machine Controls">
          <Button
            fluid
            textAlign="center"
            content="Toggle Machine"
            icon="fas fa-power-off"
            selected={data.on}
            width="50%"
            inline
            onClick={() => act('toggle_machine')} />
          <Button
            fluid
            textAlign="center"
            content="Override Power Allocator Limiter"
            icon="fas fa-exclamation-triangle"
            selected={data.override_safeties}
            width="50%"
            inline
            onClick={() => act('override_safety')} />
        </Section>
        <Section title="Allocation Controls">
          Power Allocation:
          <Slider
            value={data.power_allocation / POWER_MUL}
            minValue={0}
            maxValue={data.max_power_allocation / POWER_MUL}
            step={1}
            stepPixelSize={4}
            format={value => formatPower(value * POWER_MUL, 1)}
            onDrag={(e, value) => act('power_allocation', {
              adjust: value * POWER_MUL,
            })} />

          Available Power:
          <ProgressBar
            value={availablePower}
            minValue={0}
            maxValue={1e+6}
            color="yellow">
            {formatPower(availablePower)}
          </ProgressBar>
        </Section>
      </Window.Content>
    </Window>
  );
};
