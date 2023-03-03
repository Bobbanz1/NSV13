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
  let maximum_power = 60000000; // 60 MW
  let minimum_power = 5000000; // 5 MW
  let scale_increment = 50000000; // 50 MW
  let original_thrust = (0.65); // 0.65
  let maximum_thrust = 5;
  let input_power = 5; // 5 MW

  let increment = 0;
  let scale_factor = 0;
  let linear_maximum_v = (maximum_thrust - original_thrust);
  increment = ((maximum_power - minimum_power)/scale_increment);
  scale_factor = (linear_maximum_v/increment);

  let calculation = (original_thrust + ((input_power - minimum_power)/scale_increment * scale_factor));

  let back = data.saved_backward;

  let back_linear_maximum_v = (maximum_thrust - back);

  let back_scale_factor = (back_linear_maximum_v/increment);

  let back_calculation = (back + ((input_power - minimum_power)/scale_increment * back_scale_factor));

  let side = data.saved_side;

  let side_linear_maximum_v = (maximum_thrust - side);

  let side_scale_factor = (side_linear_maximum_v/increment);

  let side_calculation = (side + ((input_power - minimum_power)/scale_increment * side_scale_factor));

  let angular = data.saved_max_angular;

  let angular_linear_maximum_v = (maximum_thrust - angular);

  let angular_scale_factor = (angular_linear_maximum_v/increment);

  let angular_calculation = (angular + ((input_power - minimum_power)/scale_increment * angular_scale_factor));

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
        <Section title="Vessel Manueverability">
          <Box bold textAlign={"center"}>
            input_power = {input_power} <br />
            linear_maximum_v: {linear_maximum_v} <br />
            increment: {increment} <br />
            scale_factor: {scale_factor} <br />
            Calculation Value: {calculation} <br />
            <br />
            <br />
            <br />
            Forward Acceleration: {calculation} <br />
            Reverse Acceleration: {back_calculation} <br />
            Side Acceleration: {side_calculation} <br />
            Max Rotating Acceleration: {angular_calculation} <br />
            <br />
            <br />
            <br />
            Forward Thrust: {data.forward_maxthrust} / Original: {data.saved_forward} <br />
            Reverse Thrust Modified: {data.backward_maxthrust} / Original: {data.saved_backward} <br />
            Side Thrust Modified: {data.side_maxthrust} / Original: {data.saved_side} <br />
            Max Angular Acceleration Modified: {data.max_angular_acceleration} / Original: {data.saved_max_angular} <br />
          </Box>
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
